#!/bin/bash

printf "#Architecture: "
uname -a

printf "#CPU physical : "
nproc --all

printf "#vCPU : "
cat /proc/cpuinfo | grep processor | wc -l

printf "#Memory Usage: "
free -m | grep Mem | awk '{printf"%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100}'

printf "#Disk Usage: "
df -BM -a | grep /dev/mapper/ | awk '{sum+=$3}END{print sum}' | tr -d '\n'
printf "/"
df -BG -a | grep /dev/mapper/ | awk '{sum+=$2}END{print sum}' | tr -d '\n'
printf "GB ("
df -BM -a | grep /dev/mapper/ | awk '{sum1+=$3 ; sum2+=$2 }END{printf "%d", sum1 / sum2 * 100}' | tr -d '\n'
printf "%%)\n"

printf "#CPU load: "
mpstat | grep all | awk '{printf "%.1f%%\n", 100-$13}'

printf "#Last boot: "
who -b | sed 's/ system boot //g'

printf "#LVM use: "
if [ "$(sudo lvscan | grep -i ACTIVE | wc -l)" -gt 0 ] ; then printf "yes\n" ; else printf "no\n" ; fi

printf "#Connections TCP : "
ss -t | grep -i ESTAB | wc -l | tr -d '\n'
printf " ESTABLISHED\n"

printf "#User log: "
who | wc -l

printf "#Network: IP "
/sbin/ifconfig | grep broadcast | sed 's/inet//g' | sed 's/netmask.*//g' | sed 's/ //g' | tr -d '\n'
printf " ("
/sbin/ifconfig | grep 'ether ' | sed 's/.*ether //g' | sed 's/ .*//g' | tr -d '\n'
printf ")\n"

printf "#Sudo : "
grep 'sudo:' /var/log/auth.log | grep 'COMMAND=' | wc -l | tr -d '\n'
printf " cmd\n"

