#!/bin/bash
IFS=$'/'
# This script will checks optional brute force attack on the device using auth.log file
# The script will arrange the log file by users, countries, ip addreses, time and date.
 
	 
 echo "Please insert log file to explore :"
 read FILE
 echo
 echo "The attack began on $(cat $FILE | grep -i "failed password" |head -n1 |awk '{print $1, $2}') in $(cat $FILE | grep -i "failed password" |head -n1 |awk '{print $3}') o'clock" #display the date and time the beginning of the attack
 sleep 1.0
 echo "The attack ended on $(cat $FILE | grep -i "failed password" |tail -n1 |awk '{print $1, $2}') in $(cat $FILE | grep -i "failed password" |tail -n1 |awk '{print $3}') o'clock" #display the date and time the ending of the attack      
 sleep 1.0
 echo
 echo
 sleep 1.0
 IP=$(cat $FILE |grep -i "failed password" |awk '{print $(NF-3)}') #display the ip addresses in the attack
 echo "The number of attempts : $(cat $FILE | grep -i "failed password" |wc -l)" #display the number of attempts
 sleep 1.0
 echo "The number of IP addresses : $(cat $FILE |grep -i "failed password" |awk '{print $(NF-3)}'|sort |uniq|wc -l)" #display the number of the ip addresses
 sleep 1.0
  HIP=$(echo $IP |sort |uniq -c |sort -n | tail -n1) #the ip with the most attacks
  echo 
  echo
  sleep 1.0
  echo "The IP with the most attacks is $(echo $HIP |awk '{print $2}') with $(echo $HIP |awk '{print $1}') attacks"
  sleep 1.0 
  
  for i in $(echo $IP | sort |uniq) #all the ip addresses
  do 
  COUNTRY=$(echo $i |xargs -n 1 geoiplookup {} |awk '{print $5, $6, $7, $8}' |sort |uniq -c |sort -n) #the countries with the number of ip addresses that came from
  echo "The most IP addresses came from $(echo $COUNTRY |awk '{print $2, $3, $4, $5}'|tail -n1)with $(echo $COUNTRY |awk '{print $1}'|tail -n1) different IP's" #dispaly the country with the most ip addreses
  sleep 1.0
  done
  echo
  sleep 1.0
  echo
  sleep 1.0
  echo "Valid users on the attempts : $(cat $FILE |grep -i "failed password" |grep -v invalid |awk '{print $(NF -5)}' |sort |uniq |wc -l)" #display the number of valid users during the attack
  sleep 1.0
  echo "Invalid users on the attempts : $(cat $FILE |grep -i "failed password" |grep -i invalid |awk '{print $(NF -5)}' |sort |uniq |wc -l)" #display the number of invalid users during the attack
  START=$(cat $FILE |grep -i "failed password" |head -n1 |awk '{print $1, $2, $3}') #The start of the attack
  END=$(cat $FILE |grep -i "failed password" |tail -n1 |awk '{print $1, $2, $3}') #The end of the attack
  
  ACCEPT=$(sed -e '/$(echo $START)/,/$(echo $END)/p' $FILE | grep -i accepted ) #users with succsesful enterence during the attack
  if [ -z $(echo $ACCEPT) ] 
  then
  echo
  echo
  echo "There are no successful logins during the attack"
  else
  echo
  echo
  sleep 1.0
  echo "During the attack there were $(echo $ACCEPT | wc -l) successful logins with password or publickey "
  sleep 1.0
  IPS_SUC=$(echo $ACCEPT |awk '{print $11}' |sort |uniq) #the ip's with successful login
  echo "$(echo $IPS_SUC | wc -l ) different IP's with successful logins during the attack"
  echo
  echo
  sleep 1.0
  unset IFS
  for i in $IPS_SUC 
  do
  
  echo "[-]IP $(echo $i) from $(echo $i |xargs -n 1 geoiplookup {} |awk '{print $5, $6, $7, $8}')with successful login during the attack"  #display the ip and the country of each successful login
  sleep 1.0
  done
  fi
  echo
  echo
  echo
  sleep 1.0
  IFS=$(echo -en "\n\b") #split new lines
  DATE=$(cat $FILE |grep -i "failed password"|awk '{print $1,$2,$3}') #all the dates and time during the attack
  
  for y in $DATE 
  do
  IPA=$(cat $FILE |grep -i "failed password" | grep $y |awk '{print $(NF -3)}') #each ip on different date
  USER=$(cat $FILE |grep -i "failed password" | grep $y |awk '{print $(NF -5)}') #each user on different date
  echo "[*]Attack attempt on $(echo $y) IP $(echo $IPA) from $(echo $IPA|xargs -n 1 geoiplookup {} |awk '{print $5, $6, $7, $8}') with User $(echo $USER)" #display the date, ip, country and user of login attempt
  sleep  1.5
  done 
  
   
 
  
 
