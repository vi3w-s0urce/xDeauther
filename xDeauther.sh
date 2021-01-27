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
          ░${RST}                   ${G}${BOLD}~=:by G4L1L30:=~${RST}
                > ${C}\033[4mhttps://github.com/xG4L1L30x/xDeauther${RST} <
"""
}

function interface() {
  echo -e "-=[ ${Y}${BOLD}SELECT INTERFACE${RST} ]=-\n"
  ip link | grep -E "^[0-9]+" | awk -F':' '{ print $2 }' 1> log/iface.txt
  cat log/iface.txt | awk '{ print $1 }' | awk '{print "[" "\033[32m\033[1m"NR "\033[0m] " $s}'
  echo ""
  echo -ne "${bgR}${H}xDeauther${RST}:${C}${BOLD}Interface${RST} => "; read slct_interface
  echo ""
  iface=$(sed "$slct_interface!d" log/iface.txt | awk '{ print $1 }')
  if [[ $iface == "" ]] && [[ $slct_interface == 0 ]] || [[ $slct_interface =~ [a-zA-Z]+ ]]; then
    echo -e "[${R}${BOLD}!${RST}] Invalid Option! Please select number\n"
    interface
  else
    loading
    check_mode
  fi
}

function check_mode() {
  mode=$(iw $iface info | grep "type" )
  if [[ $mode == *'monitor'* ]]; then
    echo -e "\n[${G}${BOLD}*${RST}] Interface already in monitor mode"
    sleep 2
    echo -e "[${G}${BOLD}+${RST}] Set ${C}${BOLD}$iface${RST} to main interface"
    sleep 2
    clear
    banner
    weapons
  else
    echo -e "\n[${R}${BOLD}!${RST}] Interface isnt on monitor mode!"
    sleep 2
    loading2
    change_mode
  fi
}

function change_mode() {
  airmon-ng start $iface > /dev/null 2>&1
  chck=$(iw $iface info | grep "type" )
  if [[ $chck == *'monitor'* ]]; then
    echo -e "\n\n[${G}${BOLD}+${RST}] Success change to monitor mode"
    sleep 2
    echo -e "[${G}${BOLD}+${RST}] Set ${C}${BOLD}$iface${RST} to main interface"
    sleep 2
    clear
    banner
    weapons
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

function weapons() {
  echo -e "-=[ ${Y}${BOLD}SELECT WEAPONS${RST} ]=-\n"
  echo -e "[${G}${BOLD}1${RST}] mdk4 [${R}${BOLD}BRUTAL${RST}]"
  echo -e "[${G}${BOLD}2${RST}] mdk3 (Previous version mdk3)"
  echo -e "[${G}${BOLD}3${RST}] aireplay-ng [${Y}${BOLD}NORMAL${RST}]"
  echo -ne "\n${bgR}${H}xDeauther${RST}:${C}${BOLD}Weapons${RST} => "; read slct_weapons
  if [[ $slct_weapons == 1 ]]; then
    echo -e "\n[${G}${BOLD}+${RST}] Take ${R}${BOLD}mdk4${RST} to be a weapon"
  elif [[ $slct_weapons == 2 ]]; then
    echo -e "\n[${G}${BOLD}+${RST}] Take ${R}${BOLD}mdk3${RST} to be a weapon"
  elif [[ $slct_weapons == 3 ]]; then
    echo -e "\n[${G}${BOLD}+${RST}] Take ${R}${BOLD}aireplay-ng${RST} to be a weapon"
  else
    echo -e "\n[${R}${BOLD}!${RST}] Invalid Option! Please select number\n"
    weapons
  fi
  sleep 2
  clear
  banner
  target
}

function target() {
  echo -e "-=[ ${Y}${BOLD}EXPLORING TARGET${RST} ]=-\n"
  loading3&
  echo -e "[${G}${BOLD}*${RST}] Wait at least 5 second and then press CTRL+C to stop"
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
  echo -ne "\n${bgR}${H}xDeauther${RST}:${C}${BOLD}Target${RST} => "; read slct_target
  slct_target=$(($slct_target + 1))
}

function loading3() {
  for (( i = 0; i <= 10 ; i++ )); do
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

function loading2() {
  for (( i = 0; i <= 15 ; i++ )); do
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

function loading() {
  for (( i = 0; i <= 8 ; i++ )); do
    echo -ne "[${Y}―${RST}] Check interface mode...\r"
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
