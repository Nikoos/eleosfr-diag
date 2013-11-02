#!/bin/bash
#
#
VERSION="0.01"
DATE=`date +"%Y%m%d%H%M%S"`
LOG_FILE="$PWD/eleos-$DATE.log"

# Functions
#-----------------------------------------------------------------------------

displaymessage() {
  echo "$*"
}

displaytitle() {
  displaymessage "------------------------------------------------------------------------------"
  displaymessage "$*"  
  displaymessage "------------------------------------------------------------------------------"

}

displayerror() {
  displaymessage "$*" >&2
}

# First parameter: ERROR CODE
# Second parameter: MESSAGE
displayerrorandexit() {
  local exitcode=$1
  shift
  displayerror "$*"
  exit $exitcode
}

# First parameter: MESSAGE
# Others parameters: COMMAND (! not |)
displayandexec() {
  local message=$1
  echo -n "[En cours] $message"
  shift
  echo ">>> $*" >> $LOG_FILE 2>&1
  sh -c "$*" >> $LOG_FILE 2>&1
  local ret=$?
  if [ $ret -ne 0 ]; then
    echo -e "\r\e[0;31m   [ERROR]\e[0m $message"
  else
    echo -e "\r\e[0;32m      [OK]\e[0m $message"
  fi
  return $ret
}

# Debut de la génération des logs
#-----------------------------------------------------------------------------
clear

displaytitle "ElementaryOS France log compilator"
displayandexec "Gathering PCI informations (you must be connected to the Internet)" "lspci -qq -Q > pci.txt"
displayandexec "Gathering last messages from dmesg" "dmesg -T -x > dmesg.txt"
displayandexec "Gathering informations from Lshw (needs temporary root privileges)" "gksudo lshw > lshw.txt"
# Fin du script
