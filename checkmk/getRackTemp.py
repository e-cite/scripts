#!/usr/bin/env python3
import urllib3
import requests
import csv

influxdbUrl = "https://<HOST>/api/v2/query?org=<ORG>"
influxdbApiKey = "<APIKEY>"
reqData = 'from(bucket: "<BUCKET>") \
    |> range(start: -25m) \
    |> filter(fn: (r) => r["_measurement"] == "EUI_OR_MEASUREMENT") \
    |> filter(fn: (r) => r["_field"] == "Hum_SHT" or r["_field"] == "TempC_DS" or r["_field"] == "TempC_SHT") \
    |> last()'
reqHeaders = {
        "Authorization" : "Token " + influxdbApiKey,
        "Content-Type" : "application/vnd.flux",
        "Accept" : "application/csv"
    }
cmkThresholds = {
  "humRoom": {
    "warn": {
        "down": "",
        "up": "70"
    },
    "crit": {
        "down": "",
        "up": "80"
    }
  },
  "tempRoom": {
    "warn": {
        "down": "",
        "up": "28"
    },
    "crit": {
        "down": "",
        "up": "33"
    }
  },
  "tempRack": {
    "warn": {
        "down": "",
        "up": "33"
    },
    "crit": {
        "down": "",
        "up": "38"
    }
  }
}
cmkService = "Temperatures Rack"

try:
    urllib3.disable_warnings()
    resp = requests.post(influxdbUrl, data=reqData, headers=reqHeaders, verify=False)
    resp.raise_for_status()
except requests.HTTPError as e:
    cmkState = 3  # UNKNOWN
    cmkStatusDetail = "ERROR: HTTP query unsuccessful error: " + repr(e)
except Exception as e:
    cmkState = 3  # UNKNOWN
    cmkStatusDetail = "ERROR: HTTP query connection error: " + repr(e)
else:
    cmkState = 0  # OK
    try:
        reader = csv.reader(resp.text.split('\n'))
        readerlist = list(reader)
        humRoom = readerlist[1][6]
        tempRack = readerlist[2][6]
        tempRoom = readerlist[3][6]
    except Exception as e:
        cmkState = 3  # UNKNOWN
        cmkStatusDetail = "ERROR: CSV parsing error: " + repr(e)
    else:
        cmkState = 0  # OK

if cmkState == 0:
    cmkState = "P"  # dynamically compute CMK status from thresholds
    print(str(cmkState)+" "+
        "\""+cmkService+"\" "+
        "temperatureRack="+tempRack+";"+cmkThresholds['tempRack']['warn']['down']+":"+cmkThresholds['tempRack']['warn']['up']+";"+cmkThresholds['tempRack']['crit']['down']+":"+cmkThresholds['tempRack']['crit']['up']+"|"+
        "temperatureRoom="+tempRoom+";"+cmkThresholds['tempRoom']['warn']['down']+":"+cmkThresholds['tempRoom']['warn']['up']+";"+cmkThresholds['tempRoom']['crit']['down']+":"+cmkThresholds['tempRoom']['crit']['up']+"|"+
        "humidityRoom="+humRoom+";"+cmkThresholds['humRoom']['warn']['down']+":"+cmkThresholds['humRoom']['warn']['up']+";"+cmkThresholds['humRoom']['crit']['down']+":"+cmkThresholds['humRoom']['crit']['up']
    )
else:
    print(str(cmkState)+" "+
        "\""+cmkService+"\" "+
        "- "+
        cmkStatusDetail
    )
