host2=$(cat /etc/ansible/hosts | awk '{print $1}' | grep '^192')

for p in $host2

do  
    q=$(echo $p | awk -F "." '{print $4}')
    echo "$p node${q}" >> /etc/hosts   
done
