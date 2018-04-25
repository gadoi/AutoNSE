#!/usr/bin/env bash

# ***************************************
# AutoNSE - Automate Nmap Search Engine *
#        Momo Outaadi (M4ll0k)          *
#    https://github.com/m4ll0k/AutoNSE  *
# ***************************************

# colors
r='\e[1;31m'
g='\e[1;32m'
y='\e[1;33m'
b='\e[1;34m'
c='\e[1;36m'
w='\e[0;38m'
e='\e[0m'

# vars
name='AutoNSE'
author='Momo Outaadi (m4ll0k)'
version='v0.1.0'
repo='https://github.com/m4ll0k'
description='AutoNSE - Massive NSE AutoSploit/AutoScanner'
# best port
exec_command='nmap -Pn --open -p 21,22,23,25,53,80,443,455,110,123,1521,389,143,3306,27017,5984'

function banner() {
	clear
	echo -e $w"-------------------------------------"$e
	echo -e $r" _____     _       _____ _____ _____ "$e
	echo -e $r"|  _  |_ _| |_ ___|   | |   __|   __|"$e
	echo -e $r"|     | | |  _| . | | | |__   |   __|"$e
	echo -e $r"|__|__|___|_| |___|_|___|_____|_____|"$e
	echo
	echo -e $w"$description                         "$e
	echo -e $w"$name - $version                     "$e
	echo -e $w"$author                              "$e
	echo -e $w"$repo                                "$e
	echo -e $w"-------------------------------------"$e
	echo
}
function user() {
	if [ $(id -u) != "0" ]; then
		echo -e "\n$r[!]$e Please run this script with root user!"
		exit 1
	fi
}
function connect() {
	ping -c 1 -w 3 google.com > /dev/null 2>&1
	if [ "$?" != 0 ]; then
		echo -e "\n$r[!]$e This script needs an active internet connection!"
		exit 1
	fi
}
function inmap() {
	echo -e "$g[i]$e Installing nmap... please wait..."
	apt-get install nmap > /dev/null 2>&1
	if [ "$?" != 0 ]; then
		echo -e "\n$r[!]$e Nmap not installed... please try again or check your connection.."
		exit 1
	else
		echo -e "\n$g[+]$e Nmap is installed..."
	fi
}
function wnmap() {
	which nmap > /dev/null 2>&1
	if [ "$?" != 0 ]; then
		echo -e "\n$r[!]$e This script needs nmap!!"
		inmap
	fi
}
function check() {
	banner
	echo -ne $g"[+]$e Checking user..."
	user;sleep 1;echo -e $g"\t\t[✔]"$e
	echo -ne $g"[+]$e Checking connection..."
	connect;sleep 1;echo -e $g"\t[✔]"$e
	echo -ne $g"[+]$e Checking nmap..."
	wnmap;sleep 1;echo -e $g"\t\t[✔]"$e
	sleep 2
}
function exit_p() {
	echo -e "$r[!]$e Exiting..."
	sleep 1
	exit 1
}
function nmap_path() {
	path=$(whereis nmap | awk '{print $3}')
}
function search_nse() {
	nmap_path
	query=$1
	echo -e "$b[+]$e Searching $1 nse..."
	nse=$(ls "$path/scripts" |egrep -o "(^$query\S*)"|cut -d' ' -f4-|sort -b|tr '\n' ', ')
}
function scan_ftp() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading ftp nse scripts..."
	search_nse 'ftp'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 21 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_ssh() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading ssh nse scripts..."
	search_nse 'ssh'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 22 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_telnet() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading telnet nse scripts..."
	search_nse 'telnet'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 23 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_smtp() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading smtp nse scripts..."
	search_nse 'smtp'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 25 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_dns() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading dns nse scripts..."
	search_nse 'dns'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 53 $output --script=$nse --script-args dns-brute.threads=5,dns-brute.hostlist=wordlist.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_http() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading http nse scripts..."
	search_nse 'http'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 80 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_ssl() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading https/ssl nse scripts..."
	search_nse 'ssl'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 443 $output --script=$nse $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_smb() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading smb nse scripts..."
	search_nse 'smb'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 445 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_pop() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading pop3 nse scripts..."
	search_nse 'pop3'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 110 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_ntp() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading ntp nse scripts..."
	search_nse 'ntp'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 123 $output --script=$nse $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_imap() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading imap nse scripts..."
	search_nse 'imap'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 143 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_mysql() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading mysql nse scripts..."
	search_nse 'mysql'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 3306 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_mongodb() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading mongodb nse scripts..."
	search_nse 'mongodb'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 27017 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_couchdb() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading couchdb nse scripts..."
	search_nse 'couchdb'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 5984 $output --script=$nse $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scan_ldap() {
	ip=$1;output=$2
	echo -e $b"[*]$e Loading ldap nse scripts..."
	search_nse 'ldap'
	echo -e $b"[+]$e Found $(echo $nse|tr ',' '\n'|wc -l) scripts..."
	exec_command="nmap -p 389 $output --script=$nse --script-args userdb=user.txt,passdb=pass.txt $ip "
	echo -e $y"[i]$e Scanning... Please wait..."
	echo -e $w"----------------------------------------------"$e
	$exec_command
	echo -e $w"----------------------------------------------"$e
}
function scanner() {
	ip=$1;port=$2;output=$3
	if [ $port == "21" ]; then
		scan_ftp "$ip" "$output"
	fi 
	if [ $port == "22" ]; then 
		scan_ssh "$ip" "$output"
	fi
	if [ $port == "23" ]; then
		scan_telnet "$ip" "$output"
	fi
	if [ $port == "25" ]; then
		scan_smtp "$ip" "$output"
	fi 
	if [ $port == "53" ]; then
		scan_dns "$ip" "$output"
	fi
	if [ $port == "80" ]; then
		scan_http "$ip" "$output"
	fi
	if [ $port == "443" ]; then
		scan_ssl "$ip" "$output"
	fi
	if [ $port == "445" ]; then
		scan_smb "$ip" "$output"
	fi
	if [ $port == "110" ]; then
		scan_pop "$ip" "$output"
	fi
	if [ $port == "123" ]; then
		scan_ntp "$ip" "$output"
	fi
	if [ $port == "143" ]; then
		scan_imap "$ip" "$output"
	fi
	if [ $port == "3306" ]; then
		scan_mysql "$ip" "$output"
	fi
	if [ $port == "27017" ]; then
		scan_mongodb "$ip" "$output"
	fi
	if [ $port == "5984" ]; then
		scan_couchdb "$ip" "$output"
	fi
	if [ $port == "389" ]; then
		scan_ldap "$ip" "$output"
	fi
}
function ask() {
	echo
	echo -ne "    $g[+]$e Output path >> "
	read path
	echo -ne "    $g[+]$e Name of report >> "
	read filename
	echo -ne "    $g[+]$e Target IP or Host >> "
	read ip
	echo
}
function start() {
	clear
	banner
	echo -e " Select nmap output:\n"
	echo -e "  1) Output scan in xml format"
	echo -e "  2) Output scan in normal format"
	echo -e "  3) Output scan in grepable format\n"
	echo -e " 99) Exit"
	echo
	echo -n -e " AutoNSE@Sploit: ";tput sgr0
	read input
	if test $input == '1'; then
		ask
		scan="$exec_command $ip"
		result=$($scan|grep -o '[0-9]\+/'|awk -F'[^0-9]' '{print $1}')
		output="-oX $path/$filename.xml"
		for i in ${result};do
			echo -e "$g[+]$e Port $i is open.."
			scanner "$ip" "$i" "$output"
		done
	fi
	if test $input == '2'; then
		ask
		scan="$exec_command $ip"
		result=$($scan|grep -o '[0-9]\+/'|awk -F'[^0-9]' '{print $1}')
		output="-oN $path/$filename.txt"
		for i in ${result};do
			echo -e "$g[+]$e Port $i is open.."
			scanner "$ip" "$i" "$output"
		done
	fi
	if test $input == '3'; then
		ask
		scan="$exec_command $ip"
		result=$($scan|grep -o '[0-9]\+/'|awk -F'[^0-9]' '{print $1}')
		output="-oG $path/$filename.grep"
		for i in ${result};do
			echo -e "$g[+]$e Port $i is open.."
			scanner "$ip" "$i" "$output"
		done
	fi
	if test $input == '99'; then
		exit_p
	fi
}
# start
check
clear
start