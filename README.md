# nextcloud-create_mass_user
Importing users from .csv file and adding them to specific group

### Requirements
(Centos / Fedora) **glibc** [[info]](https://sourceware.org/git/?p=glibc.git)  
(Debian / Ubuntu) **libc6** [[info]](https://packages.debian.org/pl/sid/libc6)  
**dos2unix**  
**pwgen**  
**sudo**  

### Before use
Check your correct path to variables in nextuser.sh script:
- IMPORTF (paste here path, where you locate your .csv file with users.)
- CONV_PL (paste here temporary path and pay attention to add `convert.csv` at the end of line)
- CSV (as in the example above, paste correct path with `date.csv`)
- OCC (set correct path to the `occ` nextcloud script)

(all the things are not required if `/var/lib/nginx/` path exist your system)

- GROUP (set a group to assign it to users)   

Correct preparation of .csv file with a list of users.  
Example:  

Name | Surname | e-mail  
--- | --- | ---  
John   | Dąbrowski | j.dabrowski@example.com  
Eric     | Duo-Name | eric.duoname@example.com  

Make sure that double name is seperated by the dash (`-`) without whitespace!

### How to use it
---------------------------
The nextuser.sh must have permissions to call **occ** file located in webroot nextcloud, so you have few ways to run it:
- use sudo to switch to the right user and run script
`$ sudo -u nginx /usr/local/bin/nextuser.sh`
- or just change change the web-user,s shell and then run script
`$ usermod -s /bin/bash nginx`
`$ su - nginx`
`$ nextuser.sh`

In the above examples I use `nginx` web user because this is default on Centos (i.e `www-data` is default webuser in Debian). You should check first your nextcloud files owner before run script.

### Assumptions
The script creates new user accounts based on a previously prepared .csv document and assigns them to a specific group.
Then sends the notification of the new account to the user and allows to change password for that account.
The account name will be the users email

### Features
- You can use the polish special charakcters in the user name (i.e. ą, ć, ę, ü, ö... etc.)
