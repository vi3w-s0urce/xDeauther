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

function interface() {
  echo -e "${B}${BOLD}Please select interface:${RST}\n"
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
    echo -e "[${G}${BOLD}*${RST}] Interface already in monitor mode"
    target
  else
    echo -e "[${R}${BOLD}!${RST}] Interface is'nt on monitor mode!"
    sleep 1
    echo -e "[${G}${BOLD}*${RST}] Change interface mode to monitor... \n"
    sleep 3
    change_mode
    interface
  fi
}

function change_mode() {
  airmon-ng start $iface > /dev/null 2>&1
  sleep 5
  chck=$(iw $iface info | grep "type" )
  if [[ $chck == *'monitor'* ]]; then
    echo -e "[*] Success change to monitor mode"
    target
  elif [[ $chck == *'managed'* ]]; then
    echo -e "[${R}${BOLD}!${RST}] Interface doesnt supported!"
  fi
  chckmon=$(ip link | grep -E "^[0-9]+" | awk -F':' '{ print $1 $2 }' | grep "mon")
  if [[ $chckmon == *'mon'* ]]; then
    iface="${iface}mon"
  fi
}

function target() {
  xterm -e /bin/bash -l -c "airodump-ng -w log/target --output-format csv ${iface}"
  cat log/target-01.csv | sed '1d' | cut -d, -f 14,4,1,6 | awk -F',' '{print $4"," $1"," $2"," $3}' > log/showtarget.csv
  column -s, -t < log/showtarget.csv > log/target.txt
  cat log/target.txt | awk '{ print "["NR-1"]" $s }' | sed '1s/0/#/'> log/showtarget.txt
  cat log/showtarget.txt
  read
}

function quit() {
  echo -e "\n\nBye"
  airmon-ng stop $iface > /dev/null 2>&1
  rm -rf log
}

interface
