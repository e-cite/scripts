#/bin/bash
# Script to monitor Hue Sensor with checkmk
# On a client with checkmk agent installed, place this script under:
# /usr/lib/check_mk_agent/local
HUE_APIKEY=SecretApiKey # secret
HUE_IP=192.168.1.1

temp=$(curl -s --insecure -X GET https://$HUE_IP/api/$HUE_APIKEY/sensors/87 | jq '.state.temperature')
temp=$(jq -n $temp/100) # jq can also do floating point divisions
ret=$?
if [ $ret -eq 0 ]; then
  echo 0 \"Hue-Bewegungsmelder-Temperatursensor\" temp=$temp OK
else
  echo 2 \"Hue-Bewegungsmelder-Temperatursensor\" - Error
fi
