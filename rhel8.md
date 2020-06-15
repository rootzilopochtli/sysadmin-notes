# RHEL8 Notes

Notes about some configurations and tips for Red Hat Enterprise Linux 8.

### Register and configure repositories

- Register

```
[root@vmlab01 ~]# subscription-manager register
[root@vmlab01 ~]# subscription-manager attach --pool=[poolID]
[root@vmlab01 ~]# subscription-manager service-level --set=Self-Support
```

- Configure repositories and install container module

```
[root@vmlab01 ~]# subscription-manager repos --disable=*
[root@vmlab01 ~]# subscription-manager repos \
--enable rhel-8-for-x86_64-baseos-rpms \
--enable rhel-8-for-x86_64-appstream-rpms

[root@vmlab01 ~]# yum module install -y container-tools
```
