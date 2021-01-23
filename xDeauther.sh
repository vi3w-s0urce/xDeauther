#!/bin/sh

#warna
H='\e[30m'
R='\e[31m'
G='\e[32m'
B='\e[34m'
P='\e[35m'
C='\e[36m'
Y='\e[33m'
W='\e[97m'
bgH='\e[40m'
bgR='\e[41m'
bgG='\e[42m'
bgB='\e[44m'
bgP='\e[45m'
bgC='\e[46m'
bgY='\e[43m'
bgW='\e[107m'
BOLD='\e[1m'
RST='\e[0m'

trap quit EXIT
mkdir log

function interface() {
  echo -e "[${G}${BOLD}*${RST}] Please select your interface:\n"
  ip link | grep -E "^[0-9]+" | awk -F':' '{ print $1 $2 }' 1> log/iface.txt
  sed 's/\(\b[0-9]\)/\1\)/g' log/iface.txt > log/show.txt
  cat log/show.txt
  echo ""
  echo -ne "${bgR}${H}xDeauther${RST}:${C}${BOLD}Interface${RST} => "; read slct
  slctinterface=$(grep "$slct" log/iface.txt | awk -F'^[0-9]+' '{ print $2 }' | awk '{ print $1 }')
  iface=$slctinterface
  if [[ $iface == "" ]]; then
    echo -e "[${R}${BOLD}!${RST}] Invalid Option!"
    interface
  else
    check_mode
  fi
}

function check_mode() {
  mode=$(iw $iface info | grep "type" )
  if [[ $mode == *'monitor'* ]]; then
    echo -e "[${G}${BOLD}*${RST}] Interface already in monitor mode"
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
  chck=$(iw $iface info | grep "type" )
  if [[ $chck == *'monitor'* ]]; then
    echo -e "[*] Interface has change to monitor mode"
  elif [[ $chck == *'managed'* ]]; then
    echo -e "[${R}${BOLD}!${RST}] Interface doesnt supported!"
    airmon-ng stop $iface > /dev/null 2>&1
  fi
}

function quit() {
  echo -e "\n\nBye"
  rm -rf log
}

interface
