Accelerite CloudPlatform Simulator as Docker Image
---------------------

The purpose of this docker image is to run automated integration tests for the CloudStack modules in Ansible.

Setup
------------------------

The docker image runs the CloudPlatform simulator and contains two zones for the different network setups: basic and advanced networking.

CloudPlatform Zone: Sandbox-simulator-advanced
Zone: Sandbox-simulator-basic

Build
----------------------
```
docker build -t axar1990/cloudplatform-simulator . --no-cache
```

Run
--------------------
```
docker run --name cloudstack -d -p 8080:8080 -p 8096:8096 axar1990/cloudplatform-simulator
```
NOTE: It may take some time configure CloudPlatform HF8. (Max 4 to 5 Minutes)


Docker Notes:
--------------------

Ubuntu 16.04 image that contains all necessary software to compile CloudPlatform. CloudPlatform code is in `/root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/` and compiled with the simulator. MySQL database is running via supervisord. Start the container and you will enjoy CloudPlatform with a simulated data center.

```
docker pull axar1990/cloudplatform-simulator
docker run --name cloudplatform -d -p 8080:8080 -p 8096:8096 axar1990/cloudplatform-simulator
```

Open your browser at http://localhost:8080/client

Default login is admin:password

Deploy a datacenter:

```
docker exec -ti cloudplatform python \
/root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/tools/marvin/marvin/deployDataCenter.py -i /root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/setup/dev/advanced.cfg
# or 

docker exec -ti cloudplatform python \
/root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/tools/marvin/marvin/deployDataCenter.py -i /root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/setup/dev/advancedsg.cfg
# or 

docker exec -ti cloudplatform python \
/root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/tools/marvin/marvin/deployDataCenter.py -i /root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/setup/dev/basic.cfg
```

If you want to log into the container to run marvin and deploy a DC then do:

```
docker exec -ti cloudplatform /bin/bash
```
