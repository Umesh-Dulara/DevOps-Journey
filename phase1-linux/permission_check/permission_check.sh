#!/bin/bash
set -euo pipefail

echo "Following files are executable"
find /home/umesh-dulara/Desktop/devops-journey/phase1-linux -maxdepth 1 -type f -name "*.sh" -perm /111 2> /dev/null -exec sh -c 'for f; do
basename "$f"
done
' _  {} +

permissions () {
find /home/umesh-dulara/Desktop/devops-journey/phase1-linux -maxdepth 1 -type f -name "*.sh" ! -perm /111 2> /dev/null | while IFS= read -r f; do
echo "These files are not executable"
basename "$f"
if [ "$EUID" -eq "$(stat -c '%u' "$f")" ]; then
	read -p "Do you want to change the permission ? (Y/N) : " respond </dev/tty
		if [ "$respond" = "Y" ] || [ "$respond" = "y" ]; then
			chmod +x "$f"
			echo "Permisssions updated for $(basename "$f")"
		else 
			echo "Skipping ..."
		fi
	else 
		read -p "You dont own this/these file/s.Do you want to use sudo to change permissions ? (Y/N) : " respond2 </dev/tty
		if [ "$respond2" = "Y" ] || [ "$respond" = "y" ]; then
			sudo chmod +x "$f" || { echo "Failed to apply sudo permissions ! (check your password or whether you have sudo permission)"; exit 1; }
			echo "permission updated for "$f" with sudo"
		else
			echo "Skipping ..."
		fi
fi
done
}
permissions
