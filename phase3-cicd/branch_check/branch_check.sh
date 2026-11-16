#!/bin/bash
set -euo pipefail

seven_days_ago=$(( $(date +%s) - 604800 ))

remote_repo () {

git ls-remote --heads "$1"
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

git clone --bare --filter=blob:none "$1" "$tmp_dir/repo.git" 2>/dev/null
cd "$tmp_dir/repo.git" || exit 1
main_sha=$(git rev-parse refs/heads/main 2>/dev/null || git rev-parse refs/heads/master)
git for-each-ref --format='%(refname:short) %(objectname)' refs/heads/ | while read -r branch sha; do
	clean_branch="${branch#origin/}"
	if [ "$clean_branch" == "main" ] || [ "$clean_branch" == "master" ]; then
		continue
	fi

	if git merge-base --is-ancestor "$sha" "$main_sha" 2>/dev/null; then
		continue
	fi

	merge_base=$(git merge-base "$main_sha" "$sha" 2>/dev/null) || { echo "$clean_branch is an orphan branch"; exit 1; }
	last_sync_ts=$(git log -1 --format=%ct "$merge_base" 2>/dev/null)

	if [ -n "$last_sync_ts" ] && [ "$last_sync_ts" -lt "$seven_days_ago" ]; then
		readable_date=$(git log -1 --format=%cr "$merge_base")
		echo "[WARN] $clean_branch - Unmerged and last sync: $readable_date"
	fi
done
}

local_repo () {

git -C "$1" fetch --all --prune --quiet
git -C "$1" branch -a

main=$(git -C "$1" rev-parse --verify origin/main >/dev/null 2>&1 && echo "origin/main" || echo "main")

for branch in $(git -C "$1" branch -a --no-merged "$main" --format="%(refname:short)"); do

	[[ "$branch" == "origin/HEAD" ]] && continue
	merge_base=$(git -C "$1" merge-base "$main" "$branch" 2>/dev/null)

	[ -z "$merge_base" ] && continue
	last_sync_ts=$(git -C "$1" log -1 --format=%ct "$merge_base")

	if [ "$last_sync_ts" -lt "$seven_days_ago" ]; then
		readable_date=$(git -C "$1" log -1 --format=%cr "$merge_base")
		echo "[WARN] $branch - Unmerged and last sync: $readable_date"
	fi
done

}

if  grep -q '^https://' <<< "$1" ; then
	remote_repo "$1"
else
	local_repo "$1"
fi
