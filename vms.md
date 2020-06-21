# Virtual Machines

Notes about the preparation, configuration and use of virtual machines.

## Download

Useful sites for downloading qcow2 images:

- [Fedora Cloud. Cloud Base Images](https://alt.fedoraproject.org/cloud/)
- [Fedora CoreOS. Bare Metal & Virtualized](https://getfedora.org/en/coreos/download?tab=metal_virtualized&stream=stable)
- [OpenStack: Get images](https://docs.openstack.org/image-guide/obtain-images.html)

## Preparation of VM

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

**NOTE: In this example /dev/sda1 is not the /boot partition. So be careful you are growing the correct partitions on your qcow.**

- Grow <code>/dev/sda1</code> 

```
virt-resize --expand /dev/sda1 image-orig.qcow2 image.qcow2
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
sudo virt-customize -a /var/lib/libvirt/images/image.qcow2 --hostname vm01.rootzilopochtli.lab --root-password password:rootpw --ssh-inject 'root:file:labkey.pub' --uninstall cloud-init --selinux-relabel
```

## Configuring VM

### Loading the VM

- Installing the VM

```
sudo virt-install --name vm01 --memory 1024 --vcpus 1 --disk /var/lib/libvirt/images/image.qcow2 --import --os-type linux --os-variant generic --noautoconsole
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


## References

[How to Resize a qcow2 Image and Filesystem with Virt-Resize](https://fatmin.com/2016/12/20/how-to-resize-a-qcow2-image-and-filesystem-with-virt-resize/)  
[Modifying the Red Hat Enterprise Linux OpenStack Platform Overcloud Image with virt-customize](https://access.redhat.com/articles/1556833)
