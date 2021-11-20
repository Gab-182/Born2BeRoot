#!/bin/bash

#[1]
Architecture=$(uname -a)
# ---------
# The uname command displays several system information including,
# the Linux kernel architecture, name version, and release.
# -a      Behave as though all of the options -mnrsv were specified.
##############################################################################################################
# [2]
CPU_physical=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
# --------------------------------------------------------
# The file /proc/cpuinfo displays what type of processor your system is running including the number of CPUs present
# sort  ------->  The sort utility sorts text and binary files by lines.
# uniq  ------->  The uniq utility reads the specified input_file comparing adjacent lines, and writes a copy of each
#				  unique input line to the output_file.
# wc    ------->  The wc utility displays the number of lines,
# -l    ------->  -l      The number of lines in each input file is written to the standard output. 
##############################################################################################################
# [3]
vCPU=$(grep "^processor" /proc/cpuinfo | wc -l)
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
 
# NF --------> NF command keeps a count of the number of fields within the current input record. 

# NF=="/" ------> scan the root directory only.

# {printf "%d/%dGB (%s)\n", $3,$2,$5} ---------> $3 stands for The Available size.
#									  ---------> $2 stands for The Used size.
#									  ---------> $5 stands for the Percent Usage of the Disk. 

##############################################################################################################
# [6]
CPU_load=$(top -bn1 | grep load | awk '{printf "%.1f%%\n", $(NF-2)}')

# top ---------> display and update sorted information about processes.

# -bn1 --------> The -n option specifies the maximum number of iterations and -b enables batch mode operation,
#                which could be useful for sending output from top to a file.
#				 So, Basically -bn1: is just to save the result in an outbut file to we can deal with
#				 later.
# NOTE:
#======
# top -bn1 | grep load ------> will give you this result for example : [load average: 1.05, 0.70, 5.09]
#### load average over the last 1 minute: 1.05 _________________________________________|     |     |
#### load average over the last 5 minutes: 0.70 ______________________________________________|     |
#### load average over the last 15 minutes: 5.09 ___________________________________________________|

# (NF-2) -----> That is mean Take the load average in the last 1 minute.
#
##############################################################################################################
# [7]
Last_Boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
#
# who ------> The who utility displays a list of all users currently logged on.
# -b  ------> Just show the time of last system boot.  
#
# awk '$1 == "system" {print $3 " " $4}' -----> That command basically says that:
#												If the first field contain the word system print the third 
#												and the fourth field.
#
##############################################################################################################
# [8]
Lvm_check=$(lsblk | grep "lvm" | wc -l)
LVM_use=$(if [ $Lvm_check -eq 0 ]; then echo no; else echo yes; fi)
#
# The second command means that if the number of lines that contain the word (lvm) is (0) then print (no),
# else, print (yes).
#
##############################################################################################################
# [9]
Connexions_TCP=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {printf "%d ESTABLISHED\n", $3}')
#
# Read the sockstat file, then print from the (TCP, 1st field) the third field then print ESTABLISHED in the end.
#
##############################################################################################################
# [10]
User_log=$(who | wc -l)
#
# who -------> The who utility displays a list of all users currently logged on, showing for each user the login name,
#			   tty name, the date and time of login, and hostname if not local

# wc -l -------> display the number of lines in each input file is written to the standard output.
#
##############################################################################################################
# [11]
IP=$(hostname -I)
Mac=$(ip addr | awk '$1 == "link/ether" {print $2}')

# hostname ----> prints the name of the current host.
# -I ----------> To show the IP address for the hostname.
#
# ip addr -----> Type the following command to list and show all ip address associated on on all network 
# interfaces
#
##############################################################################################################
# [12]
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
# journalctl _COMM=sudo: -------> with the journald daemon, which handles all of the messages produced by the kernel,
#								  initrd, services, etc. 
# 
##############################################################################################################
# The wall utility displays the contents of file or,by default, its standard input, on the 
# terminals of all currently logged in users.

wall "#Architecture: $Architecture
	#CPU physical: $CPU_physical
	#vCPU: $vCPU
	#Memory Usage: $used_ram/${free_ram}MB ($percent_ram%)
	#Disk Usage: $Disk_usage
	#CPU load: $CPU_load
	#Last boot: $Last_Boot
	#LVM use: $LVM_use
	#Connexions TCP: $Connexions_TCP 
	#User log: $User_log
	#Network: IP $IP ($Mac)
	#Sudo: $cmds cmd" # broadcast our system information on all terminals
##############################################################################################################