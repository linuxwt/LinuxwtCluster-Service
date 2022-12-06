#!/bin/bash
while read a b;do echo $a $b >> /etc/hosts;done < ip6.txt
