#!/bin/bash   

for i in {61..71}
do
    echo 10.235.9.$i node$i >> /etc/hosts
done
