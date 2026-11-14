#!/bin/bash
set -euo pipefail

set -a
source .env
set +a

current_version="$APP_VERSION"

IFS='.' read -r MAJOR MINOR PATCH <<< "$current_version"

show_help () {

echo "Usage:"
echo "help : view help"
echo "major: Use for magor image update"
echo "minor: Use for minor image update"
echo "patch: Use for image patches"
exit 0

}

echo "Current version: $current_version"
read -rp "Select update type (major/minor/patch) (seperate multiple types with spaces): " -a CHOICES

update_version () {

for choice in "${CHOICES[@]}"; do
	if [ "$choice" == "help" ]; then
		show_help
	elif [ "$choice" == "major" ]; then
		MAJOR=$((MAJOR + 1))
	elif [ "$choice" == "minor" ]; then
		MINOR=$((MINOR + 1))
	elif [ "$choice" == "patch" ]; then
		PATCH=$((PATCH + 1))
	else
		echo "[ERROR] Invalid choice: $choice"
		echo "[INFO] Valid options are: major, minor, patch, help"
		exit 1
	fi
done

}

if [ ${#CHOICES[@]} -gt 3 ]; then
	echo "[ERROR] Too many choices"
	exit 1
elif [ ${#CHOICES[@]} -eq 0 ]; then
	read -rp "Do you want to continue with the current version number $current_version (y/n): " response
	if [[ "$response" == "Y" || "$response" == "y" ]];then
		echo "[WARN] you are using a used version tag for new build! "
	else
		exit 0
	fi
else
	update_version
fi

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

echo "Bumping version : $current_version > $NEW_VERSION"

sed -i.bak "s/^APP_VERSION=.*/APP_VERSION=$NEW_VERSION/" .env && rm -f .env.bak

export APP_VERSION="$NEW_VERSION"

