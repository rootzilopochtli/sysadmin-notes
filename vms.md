# Virtual Machines

Notes about the preparation, configuration and use of virtual machines.

## Download

Useful sites for downloading qcow2 images:

- [Fedora Cloud. Cloud Base Images](https://alt.fedoraproject.org/cloud/)
- [Fedora CoreOS. Bare Metal & Virtualized](https://getfedora.org/en/coreos/download?tab=metal_virtualized&stream=stable)
- [OpenStack: Get images](https://docs.openstack.org/image-guide/obtain-images.html)

## Preparation of VM

### Creating a new virtual network for public access

1. Create a <code>bridged-network.xml</code> configuration file:

```
<network>
    <name>bridged-network</name>
    <forward mode="bridge" />
    <bridge name="br0" />
</network>
```

2. Define as virtual network:

```
$ sudo virsh net-define bridged-network.xml
```

3. Activate and set as auto-started:

```
$ sudo virsh net-start bridged-network
$ sudo virsh net-autostart bridged-network
```

4. Verify

```
$ sudo virsh net-list
Name              State    Autostart   Persistent
----------------------------------------------------
bridged-network   active   yes         yes
default           active   yes         yes
```

5. Create/Import VM with <code>bridged-network</code> as network:

```
$ sudo virt-install --name vmlab --memory 4096 --vcpus 2 --disk /var/lib/libvirt/images/vmlab.qcow2 \
--import --os-variant centos8 --network network=bridged-network --noautoconsole
```

### Resize a qcow2 image

- Check image info

```
qemu-img info image.qcow2 
```

- Resize image

```
qemu-img resize image.qcow2 +20G
```

- To resize the underlying filesystems, we need to make a copy of the image, since virt-resize does not resize disk images in-place

```
cp image.qcow2 image-orig.qcow2
```

**NOTE: In this example /dev/vda3 is not the /boot partition. So be careful you are growing the correct partitions on your qcow.**

- Check the partitions to ensure the filesystem to be grown

```
virt-filesystems --long -h --all -a image.qcow2
```

- Grow <code>/dev/vda3</code> 

```
virt-resize --expand /dev/vda3 image-orig.qcow2 image.qcow2
```

- Inspect new disk

```
qemu-img info image.qcow2 
```

- Verify the filesystems

```
virt-filesystems --long -h --all -a image.qcow2
```

### Customize a qcow2 image

- Setting the qcow2 image

```
sudo virt-customize -a /var/lib/libvirt/images/image.qcow2 --hostname vm01.rootzilopochtli.lab \
--root-password password:rootpw --ssh-inject 'root:file:labkey.pub' --uninstall cloud-init \
--selinux-relabel
```

## Configuring VM

### Loading the VM

- Installing the VM

```
sudo virt-install --name vm01 --memory 1024 --vcpus 1 --disk /var/lib/libvirt/images/image.qcow2 --import \
--os-type linux --os-variant generic --noautoconsole
```

**Note: If you want to set the exact os-variant, check with the osinfo-query command:**

```
sudo osinfo-query os
```

## Using the VM

### Access

- Using console

```
sudo virsh console vm01
```

**NOTE: To escape from console use the key combination _ctrl+5_.**

## Fix Errors

### virt-customize: warning: random seed could not be set for this type of guest

This error , during customization, causes hostkeys not to be generated; therefore `sshd` will not start:

```
root@debian:~# systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: e>
     Active: failed (Result: exit-code) since Thu 2022-09-08 00:35:29 UTC; 32mi>
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 528 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=1/FAILURE)
        CPU: 5ms

Sep 08 00:35:29 debian.rootzilopochtli.lab systemd[1]: ssh.service: Scheduled r>
Sep 08 00:35:29 debian.rootzilopochtli.lab systemd[1]: Stopped OpenBSD Secure S>
Sep 08 00:35:29 debian.rootzilopochtli.lab systemd[1]: ssh.service: Start reque>
Sep 08 00:35:29 debian.rootzilopochtli.lab systemd[1]: ssh.service: Failed with>
Sep 08 00:35:29 debian.rootzilopochtli.lab systemd[1]: Failed to start OpenBSD >
root@debian:~# /usr/sbin/sshd
sshd: no hostkeys available -- exiting.
```

- Generate hostkeys

```
root@debian:~# ssh-keygen -A
ssh-keygen: generating new host keys: RSA DSA ECDSA ED25519
```

### virsh: cannot undefine domain with NVRAM

```
virsh undefine centos
error: Failed to undefine domain centos 
error: Requested operation is not valid: cannot undefine domain with nvram
```

**nvram** is a _device_ that is allowed to change its [address](https://libvirt.org/formatdomain.html#elementsNVRAM).

- **Solution**

```
virsh undefine --nvram centos 
```

## Export VM

- Copy qcow2 file from <code>/var/lib/libvirt/images</code> to same directory on destination host

- Create a dump xml from domain to export

```
sudo virsh dumpxml VMNAME > vmname.xml
```

- On the destination host run

```
sudo virsh define vmname.xml
```

- Start VM

## Using cloud-init

1. [Download cloud image](#download)

2. [Resize qcow2 image](#resize-a-qcow2-image)

3. With cloud-init: Configure hostname, add a user and grant him access by ssh and change the root password:

   * Create meta-data:

   ```
   cat > meta-data <<EOF
   local-hostname: vm02.rootzilopochtli.lab
   EOF
   ```

   * Create user-data:

   ```
   $ cat > user-data <<EOF
   # cloud-config

   users
   users:
   - name: dexter
     ssh_authorized_keys:
       - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD...
     sudo: ['ALL=(ALL) NOPASSWD:ALL']
     groups: sudo
     shell: /bin/bash

   chpasswd:
     list: |
       root:password
     expire: False

   runcmd:
     - echo "AllowUsers ubuntu" >> /etc/ssh/sshd_config
     - restart ssh
   EOF
   ```

   * Create a disk to attach with cloud-init configuration:

   ```
   $ sudo genisoimage  -output /var/lib/libvirt/images/vm02-cidata.iso -volid cidata -joliet -rock user-data meta-data
   ```

4. Launch VM

```
$ sudo virt-install --name vm02 --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/vm02.qcow2 \
--disk /var/lib/libvirt/images/vm02-cidata.iso,device=cdrom --import --network network=default --noautoconsole
```

5. Access the VM

   * Verify that the vm is running:

   ```
   $ sudo virsh list
    Id   Name     State
    ------------------------
    1    vm02     running
   ```

   * Get his IP address

   ```
   $ sudo virsh domifaddr vm02
     Name       MAC address          Protocol     Address
    -------------------------------------------------------------------------------
     vnet0      52:54:00:19:54:79    ipv4         192.168.122.186/24
   ```

   * Testing access with ssh

## References

- [How to Resize a qcow2 Image and Filesystem with Virt-Resize](https://fatmin.com/2016/12/20/how-to-resize-a-qcow2-image-and-filesystem-with-virt-resize/)  
- [Modifying the Red Hat Enterprise Linux OpenStack Platform Overcloud Image with virt-customize](https://access.redhat.com/articles/1556833)
- [Use Ubuntu Cloud Image with KVM](https://medium.com/@art.vasilyev/use-ubuntu-cloud-image-with-kvm-1f28c19f82f8)
- [How to use bridged networking with libvirt and KVM](https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm)
