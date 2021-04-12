#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Copyright (c) 2020, MrDoob
# All rights reserved.

RCLONEDOCKER=/opt/appdata/uploader/rclone-docker.conf

if grep -q server_side** ${RCLONEDOCKER}; then
   echo "-->> Server_side is added <<-- "
 if grep -q "\[tcrypt\]" ${RCLONEDOCKER} && grep -q "\[gcrypt\]" ${RCLONEDOCKER}; then
     echo " -->> Check for booth salt passwords <<--"
     rccommand1=$(rclone reveal $(cat ${RCLONEDOCKER} | awk '$1 == "password" {print $3}' | head -n 1 | tail -n 1))
     rccommand2=$(rclone reveal $(cat ${RCLONEDOCKER} | awk '$1 == "password" {print $3}' | head -n 2 | tail -n 1))
     rccommand3=$(rclone reveal $(cat ${RCLONEDOCKER} | awk '$1 == "password2" {print $3}' | head -n 1 | tail -n 1))
     rccommand4=$(rclone reveal $(cat ${RCLONEDOCKER} | awk '$1 == "password2" {print $3}' | head -n 2 | tail -n 1))
   if [[ "${rccommand1}" == "${rccommand2}" && "${rccommand3}" == "${rccommand4}" ]]; then
      echo " --->> Server_side can be used <<-- "
      echo " --->> TCrypt and GCrypt used the same password <<-- "
   else
       ## touch /etc/services.d/serverside/down
      echo " -->> Server_side can't be used <<-- "
      echo " -->> TCrypt and GCrypt dont used the same password <<-- "
   fi
  fi
else
   echo "-->> Server_side is not included <<--"
  ## touch /etc/services.d/serverside/down
   echo "-->> skipping <<--"
fi
sleep 10
