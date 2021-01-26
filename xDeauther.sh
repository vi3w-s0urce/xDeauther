#!/bin/sh

#warna
H='\033[30m'
R='\033[31m'
G='\033[32m'
B='\033[34m'
P='\033[35m'
C='\033[36m'
Y='\033[33m'
W='\033[97m'
bgH='\033[40m'
bgR='\033[41m'
bgG='\033[42m'
bgB='\033[44m'
bgP='\033[45m'
bgC='\033[46m'
bgY='\033[43m'
bgW='\033[107m'
BOLD='\033[1m'
RST='\033[0m'

trap quit EXIT
mkdir log

function banner() {
  echo -e """
${R}▒██   ██▒▓█████▄ ▓█████ ▄▄▄       █    ██ ▄▄▄█████▓ ██░ ██ ▓█████  ██▀███
▒▒ █ █ ▒░▒██▀ ██▌▓█   ▀▒████▄     ██  ▓██▒▓  ██▒ ▓▒▓██░ ██▒▓█   ▀ ▓██ ▒ ██▒
░░  █   ░░██   █▌▒███  ▒██  ▀█▄  ▓██  ▒██░▒ ▓██░ ▒░▒██▀▀██░▒███   ▓██ ░▄█ ▒
 ░ █ █ ▒ ░▓█▄   ▌▒▓█  ▄░██▄▄▄▄██ ▓▓█  ░██░░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄ ▒██▀▀█▄
▒██▒ ▒██▒░▒████▓ ░▒████▒▓█   ▓██▒▒▒█████▓   ▒██▒ ░ ░▓█▒░██▓░▒████▒░██▓ ▒██▒
▒▒ ░ ░▓ ░ ▒▒▓  ▒ ░░ ▒░ ░▒▒   ▓▒█░░▒▓▒ ▒ ▒   ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░░ ▒▓ ░▒▓░
░░   ░▒ ░ ░ ▒  ▒  ░ ░  ░ ▒   ▒▒ ░░░▒░ ░ ░     ░     ▒ ░▒░ ░ ░ ░  ░  ░▒ ░ ▒░
 ░    ░   ░ ░  ░    ░    ░   ▒    ░░░ ░ ░   ░       ░  ░░ ░   ░     ░░   ░
 ░    ░     ░       ░  ░     ░  ░   ░               ░  ░  ░   ░  ░   ░
          ░${RST}                   ${bgG}${H}~=:by G4L1L30:=~${RST}
                  ${C}${BOLD}\033[4mhttps://github.com/xG4L1L30x/xDeauther${RST}
"""
}

function interface() {
  echo -e "-=[ ${Y}${BOLD}SELECT INTERFACE${RST} ]=-\n"
  ip link | grep -E "^[0-9]+" | awk -F':' '{ print $2 }' 1> log/iface.txt
  cat log/iface.txt | awk '{ print $1 }' | awk '{print "[" "\033[32m\033[1m"NR "\033[0m] " $s}'
  echo ""
  echo -ne "${bgR}${H}xDeauther${RST}:${C}${BOLD}Interface${RST} => "; read slct
  slctinterface=$(sed "$slct!d" log/iface.txt | awk '{ print $1 }')
  iface=$slctinterface
  if [[ $iface == "" ]] && [[ $slct == 0 ]] || [[ $slct =~ [a-zA-Z]+ ]]; then
    echo -e "[${R}${BOLD}!${RST}] Invalid Option! Please select number."
    interface
  else
    check_mode
  fi
}

function check_mode() {
  mode=$(iw $iface info | grep "type" )
  if [[ $mode == *'monitor'* ]]; then
    echo -e "\n[${G}${BOLD}*${RST}] Interface already in monitor mode"
    sleep 2
    clear
    banner
    target
  else
    echo -e "\n[${R}${BOLD}!${RST}] Interface isnt on monitor mode!"
    sleep 2
    loading
    change_mode
  fi
}

function change_mode() {
  airmon-ng start $iface > /dev/null 2>&1
  chck=$(iw $iface info | grep "type" )
  if [[ $chck == *'monitor'* ]]; then
    echo -e "[*] Success change to monitor mode"
    clear
    banner
    target
  elif [[ $chck == *'managed'* ]]; then
    echo -e "\n\n[${R}${BOLD}!${RST}] Interface doesnt supported!"
    sleep 2
    clear
    banner
    interface
  fi
  chckmon=$(ip link | grep -E "^[0-9]+" | awk -F':' '{ print $1 $2 }' | grep "mon")
  if [[ $chckmon == *'mon'* ]]; then
    iface="${iface}mon"
  fi
}

function target() {
  echo -e "-=[ ${Y}${BOLD}EXPLORING TARGET${RST} ]=-\n"
  loading2&
  echo -e "[${G}${BOLD}*${RST}] Press CTRL+C to stop"
  xterm -e /bin/bash -l -c "airodump-ng -w log/target --output-format csv ${iface}"
  clear
  banner
  echo -e "-=[ ${Y}${BOLD}SELECT TARGET${RST} ]=-\n"
  rmline=$(grep -n "Station MAC" log/target-01.csv | awk -F':' '{ print $1 }')
  rmline=$(($rmline - 1))
  sed "${rmline}~1d" log/target-01.csv > log/target.csv
  sed '1d' log/target.csv | cut -d, -f 14,4,1,6 | awk -F',' '{ print $4"," $1"," $2"," $3 }' > log/showtarget.csv
  sed '1d' log/target.csv | cut -d, -f 14,4,1,6 | awk -F',' '{ print $1 }' > log/BSSID.txt
  sed '1d' log/target.csv | cut -d, -f 14,4,1,6 | awk -F',' '{ print $2 }' > log/channel.txt
  column -s, -t < log/showtarget.csv > log/target.txt
  awk '{ print "[""\033[32m\033[1m"NR-1"\033[0m]" $s }' log/target.txt | sed '1s/0/#/'> log/showtarget.txt
  cat log/showtarget.txt
  echo -ne "\n${bgR}${H}xDeauther${RST}:${C}${BOLD}Target${RST} => "; read slcttarget
  slcttarget=$(($slcttarget + 1))
}

function loading2() {
  for (( i = 0; i <= 12 ; i++ )); do
    echo -ne "[${Y}―${RST}] Exploring for target...\r"
    sleep 0.1
    echo -ne "[\]\r"
    sleep 0.1
    echo -ne "[${Y}￨${RST}]\r"
    sleep 0.1
    echo -ne "[${Y}/${RST}]\r"
    sleep 0.1
  done
}

function loading() {
  for (( i = 0; i <= 20 ; i++ )); do
    echo -ne "[${Y}―${RST}] Change interface mode to monitor...\r"
    sleep 0.1
    echo -ne "[\]\r"
    sleep 0.1
    echo -ne "[${Y}￨${RST}]\r"
    sleep 0.1
    echo -ne "[${Y}/${RST}]\r"
    sleep 0.1
  done
}

function quit() {
  echo -e "\n\nBye"
  airmon-ng stop $iface > /dev/null 2>&1
  rm -rf log
}

clear
banner
interface
