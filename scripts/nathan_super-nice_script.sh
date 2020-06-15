##
## Script created by Nathan Curry (ESS) to collect logs and failure messages in overcloud deployment
##

source stackrc

    echo "# 	" >> rh-$(hostname).log
    openstack server list >> rh-$(hostname).log
    echo "# openstack baremetal node list" >> rh-$(hostname).log
    openstack baremetal node list >> rh-$(hostname).log
    echo "#  openstack hypervisor list" >> rh-$(hostname).log
    openstack hypervisor list >> rh-$(hostname).log
    echo "# openstack host list" >> rh-$(hostname).log
    openstack host list >> rh-$(hostname).log
    echo "# openstack hypervisor list -c ID -f value | xargs -n1 	 " >> rh-$(hostname).log
    openstack hypervisor list -c ID -f value | xargs -n1 openstack hypervisor show >> rh-$(hostname).log
    echo "#  openstack stack list | grep -i failed" >> rh-$(hostname).log
    openstack stack list | grep -i failed >> rh-$(hostname).log
    echo "# openstack stack resource list $(openstack stack list -c ID -f value | head -1)" >> rh-$(hostname).log
    	openstack stack resource list $(openstack stack list -c ID -f value | head -1) >> rh-$(hostname).log
    echo "# openstack stack resource show $(openstack stack list -c ID -f value | head -1) AllNodesDeploySteps " >> rh-$(hostname).log
    openstack stack resource show $(openstack stack list -c ID -f value | head -1) AllNodesDeploySteps >> rh-$(hostname).log
    echo "#  openstack stack list --nested | grep -v COMPLETE" >> rh-$(hostname).log
    openstack stack list --nested | grep -v COMPLETE >> rh-$(hostname).log
    echo "# openstack stack resource list -n5 $(openstack stack list -c ID -f value | head -1) |grep -vi complete " >> rh-$(hostname).log
    openstack stack resource list -n5 $(openstack stack list -c ID -f value | head -1) |grep -vi complete >> rh-$(hostname).log
    echo "# openstack software deployment list | grep -v COMPLETE" >> rh-$(hostname).log
    openstack software deployment list | grep -v COMPLETE >> rh-$(hostname).log
    echo "# openstack software deployment list -c id -f value | xargs -n1 openstack software deployment show " >> rh-$(hostname).log
    openstack software deployment list -c id -f value | xargs -n1 openstack software deployment show >> rh-$(hostname).log
    echo "# openstack stack failures list $(openstack stack list -c ID -f value | head -1) --long " >> rh-$(hostname).log
    openstack stack failures list $(openstack stack list -c ID -f value | head -1) --long  >> rh-$(hostname).log
