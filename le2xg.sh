#!/bin/bash

# router address and port as seen from the system running Letsencrypt
ROUTER=192.168.200.1:4444

# the system where the LetsEncrypt is running
#
# 1. the 'admin' account has full api access,
#    or you can create a dedicated api user
# 2. 'api' access must be enabled at
#    Administration -> Backup & Firmware -> API
#      - Enable 'API Configuration'
#      - enter the IP addresses that should be allowed to access the API
APIUSER=my-api-user
APIPLAINPASS=my-api-password

# Complete path to xgxml.txt
XML=/root/.le/xgxml.txt

# Letsencrypt domain
# look in /etc/letsencrypt/live
LEDOMAIN=cloud.mmsionline.us

# XG Operation
#     add: this must be used once to initiate the certificate on the XG
#  update: this is used for updating the cert once it has been created
OPERATION=${1:-update}

# Overview -
# 1. copy & rename letsencrypt 'privkey.pem' to 'privkey.key'
# 2. replace placeholder variables in 'xgxml.txt' with values above
# 3. feed the result to curl
#    - listing the 3 files to be uploaded in the order they occur in the input
# 4. Delete the copy of privkey.pem that was created

cp "/etc/letsencrypt/live/$LEDOMAIN/privkey.pem" ./privkey.key

sed \
                -e "s/APIUSER/$APIUSER/" \
                -e "s/APIPLAINPASS/$APIPLAINPASS/" \
                -e "s/OPERATION/$OPERATION/" \
                -e "s/LEDOMAIN/$LEDOMAIN/" ${XML} \
| curl -k -F "reqxml=<-" \
  -F file=@/etc/letsencrypt/live/$LEDOMAIN/chain.pem \
  -F file=@/etc/letsencrypt/live/$LEDOMAIN/fullchain.pem \
  -F file=@./privkey.key \
  "https://$ROUTER/webconsole/APIController?"

 rm ./privkey.key
