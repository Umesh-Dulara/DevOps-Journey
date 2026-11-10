for file in *.sh; do
        echo " File name: "$file" File Size: $(stat "$file" | awk 'NR==2 {print $2}') bytes"
done < ~/devops-journey/phase1-linux/
