# Hardening

Secure your system.

---

## System Update

* Clean repos and update

```
# dnf clean all & dnf update 
```

> **Note: A health reset is required after upgrading.**

* Errata review

```
# dnf check-update --security
```

* Errata installation

```
# dnf update --security
```

## System Access

### Prevent reset combination
* Enable

```
# rm -rf /etc/systemd/system/ctrl-alt-del.target
# systemctl mask ctrl-alt-del.target
```

* Disable

```
# systemctl unmask ctrl-alt-del.target
```

### Access Warning Banner

* `/etc/issue`

> Este sistema es para el uso exclusivo de usuarios autorizados, por lo que las personas que lo utilicen estarán sujetos al monitoreo de todas sus actividades en el mismo. Cualquier persona que utilice este sistema permite expresamente tal monitoreo y debe estar consciente de que si este revelara una posible actividad ilicita, el personal de sistemas proporcionara la evidencia del monitoreo al personal de seguridad, con el fin de emprender las acciones civiles y/o legales que correspondan.

* `/etc/motd`

> With great powers comes great responsibility, be worthy

## Access Control

* **DAC** (_Discretionary Access Control_)
    * `chmod`
    * `chattr`

* **ACL** (_Access Control List_)
    * filesystem

* Special Permissions
    * SUID, SGID and sticky bit 

* Attributes
    * `chattr`, `lsattr`

### Find files with special permissions
* SUID

```
# find / -type f -perm /6000 -ls
```

* SGID

```
# find / -type f -perm /2000 -ls
```

### Login & Password Policy

* Review User Password Expiration Information

```
# chage -l <user>
```

* `/etc/login.defs`
    * `PASS_MAX_DAYS` **90**
    * `PASS_MIN_DAYS` **1**
    * `PASS_MIN_LEN` **8**
    * `PASS_WARN_AGE` **7**
    * `LOGIN_RETRIES` **3**
    * `LOGIN_TIMEOUT` **5**

## Services

* Review Enabled Services

```
# systemctl list-unit-files | grep enabled
```

* Review Running Services

```
# systemctl | grep running
```

### Limit resources

* Limiting root access to terminals
    * `/etc/securetty`

> **NOTE: Disabled by default in [Red Hat](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/considerations_in_adopting_rhel_8/security_considerations-in-adopting-rhel-8#securetty_security)**

* Force logout of users

    * `.bash_profile` or `/etc/profile`
        * `TMOUT=360`

* Limit access to resources
    * `/etc/security/limits.conf`

### Network

* Use static IP Address

```
# cat /etc/sysconfig/network-scripts/ifcfg-eth0 
DEVICE="eth0"
BOOTPROTO="none"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
IPADDR=192.168.0.197
PREFIX=24
GATEWAY=192.168.0.1
DNS1=192.168.0.137
```


### SSH

* SSH Keys
    * `ssh-keygen`
    * `ssh-copy-id`

* `/etc/ssh/sshd_config`

```
Port 18022
Protocol 2
ListenAddress 192.168.0.197
PermitRootLogin no
LoginGraceTime 30
PermitEmptyPasswords no
X11Forwarding no
Allow users tux linus
Banner /etc/issue
```

### HTTPD

* **Keep it updated!**
* Add support for encrypted connections (**SSL**)
* Analyze the use of security modules
    * `mod_security`
    * `mod_evasive`
    * `mod_access`
    * `mod_authz`
* Analyze the use case
* Test configurations before applying in production
    * `# apachectl configtest`
    * `# apachectl gracefull`

####  Restrict access

* `.htaccess`
* `htpasswd`

```
# htpasswd -cm /etc/httpd/.htpasswd <user>

# vi /etc/httpd/conf/httpd.conf
         <Directory /var/www/html/test.example.com/private>
             AuthName "Secret Stuff"
             AuthType Basic
             AuthUserFile /etc/httpd/.htpasswd
             Require valid-user
         </Directory>

# mkdir /var/www/html/test.example.com/private
# echo "Texto secreto" > /var/www/html/test.example.com/private/index.html

# systemctl restart httpd
```

### DNS

* Logging
    * `/etc/named.conf`

```
logging {
  channel archivo {
      file "named.log" versions 9 size 10M;
      print-time yes;
      print-category yes;
      print-severity yes;
  };
  category default { archivo; default_syslog; };
};
```
---
