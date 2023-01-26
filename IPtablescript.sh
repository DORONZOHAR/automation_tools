#!/bin/bash
#This script is for creating inbound and outbound rules for firewall using iptables.
function root()
{
if [ $(id -u) == "0" ] #make sure the user is root.
then
    echo "[✔] You are root"
    sleep 1.03
else
    echo "[x] You are not root, must be root to run this script"    
    sleep 1.0
    exit
fi      
}


function IOF() #function for input output and forward
{
	clear
	POLICY=$(iptables -t filter -L $1 --line-numbers |awk '{print $4}' |sed 's/)//g' |head -n1) #display if the policy on ACCEPT or DROP mode
if [ $POLICY == ACCEPT ] # in case of accept mode
then
    echo 
    echo "[*]Your policy ($1) is on ACCEPT mode (allow all the $2 traffic automatically)" #choose drop or accept mode
  	echo "   Do yo want to disallow $2 trrafic automatically (DROP mode)? (Y/n)" ; read policy_change
  	echo
  if [[ "$policy_change" == "Y" || "$policy_change" == "y" ]] #if so, policy drop will be on
  then
     iptables -P $1 DROP
     clear
  elif [[ "$policy_change" == "N" || "$policy_change" == "n" ]] #if so, policy accept will stay on
  then
      clear   
  fi
  
  
elif [ $POLICY == DROP ] #in case of drop mode
then 
    echo
    echo "Your policy ($1) is on DROP mode (disallow all $2 traffic automatically)" #choose drop or accept mode
  	echo "Do you want to allow the $2 trrafic automatically (ACCEPT mode)? (Y/n)" ; read policy_change
    echo  	
  	    if [[ "$policy_change" == "Y" || "$policy_change" == "y" ]]	#if so, policy accept will be on
        then
            iptables -P $1 ACCEPT
            clear
        elif [[ "$policy_change" == "N" || "$policy_change" == "n" ]] #if so, policy drop will stay on  
        then
            clear 
        fi
fi  

}
function choosing()
{
    echo "Enter the protocol type to use (tcp/udp/icmp/all/...)" #protocol type to allow or disallow
    read protocol       
    flag_ip=$1 #the flag for the IP
    echo "[1]for specify exist $3 IP list " #choosing between specifing or creating ip list
    echo "[2]for creating $3 IP list"
    echo "[3]for no $3 IP addresses"
    read choose_ip
                 if [ $choose_ip == 1 ] #if so, the user will enter his own ip list
                 then 
                 clear
                 echo "Enter your IP list :"
                 read ip_address
                 ip_list=$(cat $ip_address)
                 
                 elif [ $choose_ip == 2 ] #if so, the user will make an ip list
                 then
                 clear
                 echo "Enter an IP or a list of IP addresses to use(type 'q' to finish): " 
                     while true; do
                     read ip_address # Ask the user for input
        
                     if [[ "$ip_address" == "q" || "$ip_address" == "Q" ]] 
                     then
                     # If so, break out of the loop
                     break
                     fi

                     # Add the IP address to the IP list
                     ip_list+=("$ip_address")
                     done
                  elif [ $choose_ip == 3 ] #if so, the user will not choose IP at all
                  then
                  ip_list=empty
                  flag_ip=''     
                  fi
                  clear
                          flag_port=$2 #the flag for the port
                          echo "[1]for specify exist $3 port list " #choosing between specifing or creating port list
                          echo "[2]for creating $3 port list"
                          echo "[3]for no $3 ports "      
                                read choose_port
                                if [ $choose_port == 1 ] #if so, the user will enter his own port list
                                then 
                                echo "Enter your port list :"
                                read port_number
                                port_list=$(cat $port_number)
                                elif [ $choose_port == 2 ] #if so, the user will make a port list
                                then
                                echo "Enter a port number or a list of ports to use (type 'q' to finish): " 
                                  while true; do
                                  read port_number # Ask the user for input
        
                                   if [[ "$port_number" == "q" || "$port_number" == "Q" ]] 
                                   then
                                   # If so, break out of the loop
                                   break
                                   fi

                                  # Add the port to the port list
                                  port_list+=("$port_number")
                                  done
                                elif [ $choose_port == 3 ]  #if so, the user will not choose ports at all
                                then
                                port_list=empty
                                flag_port=''
                                fi
                                clear
                                
    flag_ip2=$4 #the flag for the other IP addresses (dst /src)
    echo "[1]for specify exist $5 IP list " #choosing between specifing or creating ip list
    echo "[2]for creating $5 IP list"
    echo "[3]for no $5 IP addresses"
    read choose_ip2
                 if [ $choose_ip2 == 1 ] #if so, the user will enter his own ip list
                 then 
                 clear
                 echo "Enter your IP list :"
                 read ip_address2
                 ip_list2=$(cat $ip_address2)
                 
                 elif [ $choose_ip2 == 2 ] #if so, the user will make an ip list
                 then
                 clear
                 echo "Enter an IP or a list of IP addresses to use(type 'q' to finish): " 
                     while true; do
                     read ip_address2 # Ask the user for input
        
                     if [[ "$ip_address2" == "q" || "$ip_address2" == "Q" ]] 
                     then
                     # If so, break out of the loop
                     break
                     fi

                     # Add the IP address to the IP list
                     ip_list2+=("$ip_address2")
                     done
                  elif [ $choose_ip2 == 3 ] #if so, the user will not choose IP at all
                  then
                  ip_list2=empty
                  flag_ip2=''     
                  fi
                  clear
                          flag_port2=$6 #the flag for the port
                          echo "[1]for specify exist $5 port list " #choosing between specifing or creating port list
                          echo "[2]for creating $5 port list"
                          echo "[3]for no $5 ports "      
                                read choose_port2
                                if [ $choose_port2 == 1 ] #if so, the user will enter his own port list
                                then 
                                echo "Enter your port list :"
                                read port_number2
                                port_list2=$(cat $port_number2)
                                elif [ $choose_port2 == 2 ] #if so, the user will make a port list
                                then
                                echo "Enter a port number or a list of ports to use (type 'q' to finish): " 
                                  while true; do
                                  read port_number2 # Ask the user for input
        
                                   if [[ "$port_number2" == "q" || "$port_number2" == "Q" ]] 
                                   then
                                   # If so, break out of the loop
                                   break
                                   fi

                                  # Add the port to the port list
                                  port_list2+=("$port_number2")
                                  done
                                elif [ $choose_port2 == 3 ]  #if so, the user will not choose ports at all
                                then
                                port_list2=empty
                                flag_port2=''
                                fi                                                                  
                                                   
                               
                                
}
function command()
{
    
    POLICY=$(iptables -t filter -L $1 --line-numbers |awk '{print $4}' |sed 's/)//g' |head -n1) #display the policy again to match it with the command
      if [ $POLICY == DROP ] ; then mode='ACCEPT' ;elif [ $POLICY == ACCEPT ] ;then mode='DROP' 
      fi
         for i in $(echo ${ip_list[@]}) ;do  #defines the variables in the first ip list
           if [ "$i" == "empty" ] ; then i='' ;elif [ "$i" != "empty" ];then flag_ip=$2 ;fi #if no IP has been chosed
             for y in $(echo ${port_list[@]}) ; do #defines the variables in the first port list
                  if [ "$y" == "empty" ] ; then y=''; elif [ "$y" != "empty" ];then flag_port=$3 ;fi #if no port has been chosen
                      for si in $(echo ${ip_list2[@]}) ; do #defines the variables in the second ip list
                         if [ "$si" == "empty" ] ; then si='' ;elif [ "$si" != "empty" ];then flag_ip2=$4 ;fi
                            for sy in $(echo ${port_list2[@]}) ; do #defines the variables in the second port list 
                               if [ "$sy" == "empty" ] ; then sy='' ;elif [ "$sy" != "empty" ];then flag_port2=$5 ;fi
         iptables -t filter -I $1 -p $protocol $flag_ip $i $flag_port $y $flag_ip2 $si $flag_port2 $sy -j $mode     #the final command with all the user has chosen     
                              
               echo "Chain $1 has been updated for protocol $protocol, $8 IP $i  --- $si  , $8 port $y  --- $sy  on $mode policy on $(date)" >> IPtables.log  #inject the the message to a new log file      
                      done
                  done   
             done
         done
         echo >> IPtables.log
         echo >> IPtables.log
    echo "[*]The new rules have been configured."
    read -p "[-]Do you want to do the same actions to the $7 ($6) direction as well? (Y/n)  " opposite #do the same command to the opposite direction
                          if [[ $opposite == Y || $opposite == y ]]; then
                          POLICY=$(iptables -t filter -L $6 --line-numbers |awk '{print $4}' |sed 's/)//g' |head -n1) #display the policy again to match it with the command
                              if [ $POLICY == DROP ] ; then mode='ACCEPT' ;elif [ $POLICY == ACCEPT ] ;then mode='DROP' ;fi

                          flag_ip=$4
                          flag_port=$5
                          flag_ip2=$2
                          flag_port2=$3
                                for i in $(echo ${ip_list[@]}) ;do  
                                         if [ "$i" == "empty" ] ; then i='' ; flag_ip='' ; fi 
                                    for y in $(echo ${port_list[@]}) ; do 
                                              if [ "$y" == "empty" ] ; then y='' ; flag_port='' ;fi 
                                         for si in $(echo ${ip_list2[@]}) ; do    
                                                  if [ "$si" == "empty" ] ; then si='' ; flag_ip2='' ; fi  
                                             for sy in $(echo ${port_list2[@]}) ; do 
                                                      if [ "$sy" == "empty" ] ; then sy='' ; flag_port2='' ; fi  
                     iptables -t filter -I $6 -p $protocol $flag_ip $i $flag_port $y $flag_ip2 $si $flag_port2 $sy -j $mode   #the final command with all the user has chosen     
                                                    
                                    echo "Chain $6 has been updated for protocol $protocol, $9 IP $si  ---  $i , $9 port  $sy ---  $y on $mode policy on $(date)" >> IPtables.log  #inject the the message to a new log file     
                                                                          
                                           done 
                                       done
                                   done
                               done 
                               unset i ; unset y ; unset protocol ; unset ip_list ; unset port_list ; unset mode ; unset port_number ; unset ip_number ; unset  ip_list2 ; unset port_list2 ; unset ip_number2 ; unset port_number2 ; unset si ; unset sy
                               echo "[+]Opposite direction has been configured as well"
                               sleep 4.0
                           elif [[ $opposite == N || $opposite == n ]] ; then  
                           unset i
                           unset y  
                           unset protocol
                           unset ip_list
                           unset port_list
                           unset mode
                           unset port_number
                           unset ip_number  
                           unset si
                           unset sy
                           unset ip_list2
                           unset port_list2    
                           unset port_number2
                            unset ip_number2  
                                                             
                          fi 
                          
    
} 
   
          
function chain() #choosing the chain to work on
{
	echo 
	echo "[-]Choose the chain that you want to work on"
	echo
	echo "[1]INPUT (for incoming trrafic)"
	echo "[2]OUTPUT (for outgoing trrafic)"
	echo "[3]FORWARD (for passing trrafic)"
	echo
	read chain_choose 

if [ $chain_choose == 1 ]     
then
    IOF INPUT incoming #the function with the variable INPUT will be worked on
    choosing '-s' '--sport' source '-d' destination '--dport'  
    command INPUT '-s' '--sport' '-d' '--dport' OUTPUT outgoing source destination
                       
elif [ $chain_choose == 2 ]   
then
    IOF OUTPUT outgoing #the function with the variable OUTPUT will be worked on
    choosing '-d' '--dport' destination '-s' source '--sport'
    command OUTPUT '-d' '--dport' '-s' '--sport' INPUT  incoming  destination source 
elif [ $chain_choose == 3 ]  
then
    IOF FORWARD passing #the function with the variable FORWARD will be worked on
    choosing '-s' '--sport' source '-d' destination '--dport'
    command FORWARD '-s' '--sport' '-d' '--dport' FORWARD  other source destination
fi 
clear
echo "[1]Menu (for more rules)"
echo "[2]Finish"
read back
case $back in

1)chain
;;
2)echo "[+]All the new rules have been saved to a log file called 'IPtables.log'"
  echo >> IPtables.log 
  echo >> IPtables.log 
  iptables-save >> /etc/iptablescript-rules
  echo 
  echo "[+]All the new rules have been saved to a file in 'etc' directory called 'iptablescript-rules'"
  read -p "[*]Do you want the changes to be saved after reboot as well? (Y/n)  " change
  
  if [[ "$change" == "Y" || "$change" == "y" ]] ; then
  echo "pre-up < iptables-restore /etc/iptablescript-rules" >> /etc/network/interfaces
  echo
  echo "[+]All the changes have been saved!"
  echo "Goodbye!"
  sleep 1.0
  exit
  elif [[ "$change" == "N" || "$change" == "n" ]] ;then
  echo
  echo "Goodbye!"
  sleep 1.0
  exit
  fi
;;
esac  
}     	

root
chain






  	
  	
  	
  	
  	
  	
