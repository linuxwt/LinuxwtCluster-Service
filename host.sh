host2=$(cat /etc/ansible/hosts | awk '{print $1}' | grep '^10')

for p in $host2

do  
    q=$(echo $p | awk -F "." '{print $4}')
    ssh $p "hostnamectl set-hostname node${q}"    
done
