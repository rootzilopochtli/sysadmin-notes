# iSCSI

_Internet Small Computer System Interface_ (**iSCSI**) is a TCP/IP-based protocol for sending SCSI commands over IP networks. iSCSI emulates a high-performance local SCSI storage bus, enabling block-based storage devices on a server to appear as local devices on a client. 

---

## Installing Portal

* Install package

```
# dnf install targetcli
```

* Enable and start service

```
# systemctl enable --now target
```

* Add the access port in the firewall

```
# firewall-cmd --permanent --add-port=3260/tcp
# firewall-cmd --reload
```

* Create server directory

```
# mkdir -p /srv/iscsi
```

* Create backingstore

```
# dd if=/dev/zero of=/srv/iscsi/backingstore bs=1 count=0 seek=1G
```

### Configuring iSCSI storage

```
# targetcli /backstores/fileio create storage /srv/iscsi/backingstore
# targetcli /iscsi create iqn.2022-03.com.example.lab:target1
# targetcli /iscsi/iqn.2022-03.com.example.lab:target1/tpg1/acls/ \
  create iqn.2022-03.com.example.lab:client
# targetcli iscsi/iqn.2022-03.com.example.lab:target1/tpg1/luns/ \
  create /backstores/fileio/storage
```

## Installing Client

* Install package

```
# dnf install iscsi-initiator-utils
```

* Enable and start service

```
# systemctl enable --now iscsi
```

### Configuring iSCSI initiator

* Add `InitiatorName` to `/etc/iscsi/initiatorname.iscsi`

```
# echo "InitiatorName=iqn.2022-03.com.example.lab:client" \
  > /etc/iscsi/initiatorname.iscsi
```

* Modify `/etc/iscsi/iscsid.conf`

```
node.session.timeo.replacement_timeout = 5
node.conn[0].timeo.login_timeout = 5
node.conn[0].timeo.logout_timeout = 5
node.session.err_timeo.abort_timeout = 5
node.session.initial_login_retry_max = 2
```

### Dicover iSCSI targets

```
# iscsiadm -m discovery -t st -p portal.lab.example.com
```

### Login iSCSI targets

```
# iscsiadm -m node -T iqn.2022-03.com.example.lab:target1 -l
```

## Test Client

```
# fdisk -l
```

**NOTE: The LUN appears as part of the local devices managed by the operating system, for example, as the `/dev/sda` disk.**
