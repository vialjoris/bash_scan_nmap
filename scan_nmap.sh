#!/bin/bash

GREEN="\\033[1;32m"
RED="\\033[1;31m"
COLOR_OFF="\\033[0;39m"

nmap --version > /dev/null  2>&1
ret=$?    
if [ $ret -eq 127 ];then
    echo -e ${GREEN}" info:${COLOR_OFF} Installation du paquet nmap"
    sudo apt-get install nmap -y
fi

xsltproc --version > /dev/null 2>&1
ret=$?    
if [ $ret -eq 127 ];then
    echo -e ${GREEN}" info:${COLOR_OFF} Installation du paquet xsltproc"
    sudo apt-get install xsltproc -y
fi

function usage(){
  echo -e ${GREEN}" usage:${COLOR_OFF} ./scan_nmap.sh [hosts_scan_ip/hosts_scan_FQDN]"
  exit 1; 
}

function scan_nmap(){    
    echo "Scanning with vulners script ..."
    nmap -sV --script vulners --script-args mincvss=5.0 -oA "./reports/reports" "$@"
}

function convert_xml_to_html_report(){
    xsltproc -o "./reports/reports.html" ./nmap-bootstrap.xsl "./reports/reports.xml"
}

if [ -z "$1" ]; then
    usage
fi

case $1 in
    --help) usage ;;
    *) scan_nmap $@ && convert_xml_to_html_report
    ;;
esac