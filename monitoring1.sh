#!/bin/bash

#[1]
# uname -a
# ---------
# The uname command displays several system information including,
# the Linux kernel architecture, name version, and release.
# -a      Behave as though all of the options -mnrsv were specified.
##############################################################################################################
# [2]
# grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
# --------------------------------------------------------
# The file /proc/cpuinfo displays what type of processor your system is running including the number of CPUs present
# sort  ------->  The sort utility sorts text and binary files by lines.
# uniq  ------->  The uniq utility reads the specified input_file comparing adjacent lines, and writes a copy of each
#				  unique input line to the output_file.
# wc    ------->  The wc utility displays the number of lines,
# -l    ------->  -l      The number of lines in each input file is written to the standard output. 
##############################################################################################################
# [3]
# grep "^processor" /proc/cpuinfo | wc -l)
# ----------------------------------------
# The file /proc/cpuinfo displays what type of processor your system is running including the number of CPUs present
# wc    ------->  The wc utility displays the number of lines,
# -l    ------->  -l      The number of lines in each input file is written to the standard output. 
##############################################################################################################
# [4]
free_ram=$(free -m | awk '$1 == "Mem:" {print $2}') 
used_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
percent_ram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# free  -------> The free command will show me all the info about the memory[ free, used, total, shared.... ]

# -m    -------> The output will be in megabytes.

# awk '$1 == "Mem:" {print $2}'): ------> we grab the line with Mem and printing the second field
# 										  of that line which is the (free memory field) by using (awk) command.
##############################################################################################################
# [5]
Disk_usage=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')

# df ------> The df command stands for disk free, and it shows you the amount of space taken up by different drives.
# 			 By default, df displays values in 1-kilobyte blocks.

# -h ------> You can display disk usage in a more human-readable format by adding the -h option.

# awk ------> Awk  scans  each  input file for lines that match
#             any of a set of patterns specified  literally  in prog  or  in  one  or  more files 
#	          specified as -f progfile.
 
# NF --------> number of fields in the current record

# NF=="/" ------> scan the root directory only.

# {printf "%d/%dGB (%s)\n", $3,$2,$5} ---------> $3 stands for The Available size.
#									  ---------> $2 stands for The Used size.
#									  ---------> $5 stands for the Percent Usage of the Disk. 

##############################################################################################################
# [6]
CPU_load=$(top -bn1 | grep load | awk '{printf "%.1f%%\n", $(NF-2)}')

# top ---------> display and update sorted information about processes.

# -bn1 --------> 
#
#
##############################################################################################################
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
##############################################################################################################
lvmt=$(lsblk | grep "lvm" | wc -l)
##############################################################################################################
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
##############################################################################################################
ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
##############################################################################################################
ulog=$(users | wc -w)
##############################################################################################################
ip=$(hostname -I)
##############################################################################################################
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
##############################################################################################################
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
##############################################################################################################
# The wall utility displays the contents of file or,by default, its standard input, on the 
# terminals of all currently logged in users.

wall "#Architecture: uname -a
	#CPU physical: grep "physical id" /proc/cpuinfo | sort | uniq | wc -l
	#vCPU: grep "^processor" /proc/cpuinfo | wc -l
	#Memory Usage: $used_ram/${free_ram}MB ($percent_ram%)
	#Disk Usage: $Disk_usage
	#CPU load: $CPU_load
	#Last boot: $lb
	#LVM use: $lvmu
	#Connexions TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd" # broadcast our system information on all terminals
##############################################################################################################