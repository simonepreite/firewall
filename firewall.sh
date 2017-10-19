#!/bin/bash

IPTABLES="/sbin/iptables"
IP6TABLES="/sbin/ip6tables"

start()
{

#IPv4

$IPTABLES -F INPUT
$IPTABLES -F OUTPUT
$IPTABLES -F FORWARD

$IPTABLES -P FORWARD DROP
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport 53 -j ACCEPT        #DNS
$IPTABLES -A FORWARD -p udp --dport 53 -j ACCEPT        #DNS
$IPTABLES -A FORWARD -p tcp --dport 80 -j ACCEPT        #HTTP
$IPTABLES -A FORWARD -p tcp --dport 8008 -j ACCEPT      #HTTP
$IPTABLES -A FORWARD -p tcp --dport 443 -j ACCEPT       #HTTPS
$IPTABLES -A FORWARD -p tcp --dport 22 -j ACCEPT        #SSH
$IPTABLES -A FORWARD -p tcp --dport 25 -j ACCEPT        #SMTP
$IPTABLES -A FORWARD -p tcp --dport 465 -j ACCEPT       #SMTP
$IPTABLES -A FORWARD -p tcp --dport 587 -j ACCEPT       #SMTP
$IPTABLES -A FORWARD -p tcp --dport 993 -j ACCEPT       #IMAP
$IPTABLES -A FORWARD -p tcp --dport 995 -j ACCEPT       #POP
$IPTABLES -A FORWARD -p tcp --dport 111 -j ACCEPT       #RCPBIND
$IPTABLES -A FORWARD -p tcp --dport 8090 -j ACCEPT      #??
$IPTABLES -A FORWARD -p tcp --dport 889 -j ACCEPT       #LDAP
$IPTABLES -A FORWARD -p tcp --dport 636 -j ACCEPT       #LDAPSSL
$IPTABLES -A FORWARD -p tcp --dport 2049 -j ACCEPT      #NFS
$IPTABLES -A FORWARD -p tcp --dport 2000 -j ACCEPT      #CISCO


#IPv6

$IP6TABLES -F INPUT
$IP6TABLES -F OUTPUT
$IP6TABLES -F FORWARD

$IP6TABLES -P FORWARD DROP
$IP6TABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
$IP6TABLES -A FORWARD -p tcp --dport 53 -j ACCEPT        #DNS
$IP6TABLES -A FORWARD -p udp --dport 53 -j ACCEPT        #DNS
$IP6TABLES -A FORWARD -p tcp --dport 80 -j ACCEPT        #HTTP
$IP6TABLES -A FORWARD -p tcp --dport 8008 -j ACCEPT      #HTTP
$IP6TABLES -A FORWARD -p tcp --dport 443 -j ACCEPT       #HTTPS
$IP6TABLES -A FORWARD -p tcp --dport 22 -j ACCEPT        #SSH
$IP6TABLES -A FORWARD -p tcp --dport 25 -j ACCEPT        #SMTP
$IP6TABLES -A FORWARD -p tcp --dport 465 -j ACCEPT       #SMTP
$IP6TABLES -A FORWARD -p tcp --dport 587 -j ACCEPT       #SMTP
$IP6TABLES -A FORWARD -p tcp --dport 993 -j ACCEPT       #IMAP
$IP6TABLES -A FORWARD -p tcp --dport 995 -j ACCEPT       #POP
$IP6TABLES -A FORWARD -p tcp --dport 111 -j ACCEPT       #RCPBIND
$IP6TABLES -A FORWARD -p tcp --dport 8090 -j ACCEPT      #??
$IP6TABLES -A FORWARD -p tcp --dport 889 -j ACCEPT       #LDAP
$IP6TABLES -A FORWARD -p tcp --dport 636 -j ACCEPT       #LDAPSSL
$IP6TABLES -A FORWARD -p tcp --dport 2049 -j ACCEPT      #NFS
$IP6TABLES -A FORWARD -p tcp --dport 2000 -j ACCEPT      #CISCO

}


stop()
{

#Flush regole e policy in accept

$IPTABLES -F
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT


}

status()
{

$IPTABLES -L
$IP6TABLES -L

}


case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
      stop
    start
    ;;
  status)
        $IPTABLES -L -v
        ;;
  *)
        echo "Usage: $0 {start | stop | status}"
        exit 1
        ;;
esac
exit 0
