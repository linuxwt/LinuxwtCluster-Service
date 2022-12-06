host1=`cat /etc/ansible/hosts | awk -F " " '{print $1}' | grep '^10'`
for i in $host1;
do
    password="xxxx"
    /usr/bin/expect -c "
        spawn ssh-copy-id root@$i 
        expect {
        \"*(yes/no)\" {send \"yes\r\";exp_continue }
        \"*password\" { send \"$password\r\"; exp_continue }
        }     
expect eof"    
done
