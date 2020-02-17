# sophos
Notes &amp; Tools related to sophos products


## letsencrypt

### The problem
* You already have letsencrypt running on your ubuntu server.
* You want to leverage the Sophos XG WAF (Web Access Firewall) to protect your server
* You don't want to wait for Sophos to implement Letsencrypt support 

### The solution

#### create a secure directory on your Ubuntu server

This folder will contain a script with your firewall's API password in plain text.

Create the folder and set the permissions to '700' (as used by certbot for /etc/letsencrypt/accounts):

```
sudo -i
mkdir ~/.le
chmod 700 ~/.le
cd ~/.le
```

#### download the script and the xml template

```
sudo -i
cd ~/.le
curl https://raw.githubusercontent.com/mmccarn/sophos/master/le2xg.sh >le2xg.sh
curl https://raw.githubusercontent.com/mmccarn/sophos/master/xgxml.txt >xgxml.txt
```

#### Update Settings

##### On your Sophos XG Firewall
Enable API access 
* Administration -> Backup & Firmware -> API
  * Enable 'API Configuration'
  * Enter the IP address(es) that should have access to the API

Optionally create a dedicated API user
* Authentication -> Users -> Add
  
  API users don't need full admin rights, but you'll probably find testing easier if you start with full rights.

##### On your Ubuntu server
edit le2xg.sh and set the values that are specific to your network
* ROUTER 
* APIUSER
* APIPLAINPASS
* XML
* LEDOMAIN

The Sophos API documentation examples include only encrypted passwords, but searching online shows that there is no way for you to discover the correct value to use for this. The example I found on how to find the encrypted password indicates that I need to click on a link in the Sophos User Admin screen that does not exist.  I also found bugs indicating the the encrypted password function doesn't work.

#### Create the Certificate entries in your XG
```
sudo -i
cd ~/.le
./le2xg.sh add
```

#### Update your LetsEncrypt certificates
```
sudo -i
cd ~/.le
./le2xg.sh
```

#### Schedule automatic updates
[untested]
certbot's "--deploy-hook" allows you to specify a script to run if your certificate was successfully updated.

To update the Sophos XG any time the LetsEncrypt certificate is renewed, add "--deploy-hook" to your existing cron job

```
# m h  dom mon dow   command
 30 2   *   *   *    /usr/bin/certbot renew --deploy-hook /root/.le/le2xg.sh >> /var/log/le-renew.log
```

## Todo
1. [in progress] document procedures for scheduling
1. add 'test' function to test API connection to sophos
1. document use of /etc/letsencrypt/renewal-hooks/deploy
1. move settings to a separate file
    * prompt for settings on first run
    * run 'add' if settings file does not exist
    * run 'update' if settings file does exist
1. improve reporting and error handling
    * currently there is none..

## References
* [letsencrypt privkey.pem is the key file](https://stackoverflow.com/questions/50389883/generate-crt-key-ssl-files-from-lets-encrypt-from-scratch)
* [configure sophos xg for API access](https://techbast.com/2019/10/sophos-xg-firewall-how-to-use-api.html)
* [upload certificates to Sophos XG using API](https://community.sophos.com/products/xg-firewall/f/sophos-xg-firewall-general-discussion/102208/upload-certificate-using-api)
* [api access should use passwordform="plain"](https://community.sophos.com/products/xg-firewall/sfos-eap/v16/f/sfos-v16-beta-issues-bugs/79383/api-login-with-encrypted-password/320699)
