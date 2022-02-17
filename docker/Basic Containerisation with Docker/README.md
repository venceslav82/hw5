Whole cicle is automated

1. Creating Vagrant file using:
    - my own box "ivelin1936/VCentos"
    - With host name pointed for first home work for docker created by me Ivo - 'docker.hw1.ivo'
    - with private_network and forwarded_port guest:host 8080:8080
    - Provided docker set up bash script
    - and synced_folder folder 'resources' where will be placed index.html and Dockerfile
    - with virtual machine name 'CentosOS_HOST'
2. Crating simple index.html file into 'resources' folder
3. Creating simple Dockerfile from centos:centos7, into 'resources' folder
    - With maintainer Ivelin Dimitrov (me)
    - RUN some bash commands for updating yum, installing apache server and cleaning /var/lib/apt/yum/ folder recursively
    - Run/start appache server in foreground - /usr/sbin/apache2 -D FOREGROUND ...
    - Expose port 80
4. Creating docker-setup bash script
    - Adding the virtual machine host to etc/hosts, for SSH...
    - Trying to remove docker packages if there are any (in our case doesnt exist)
    - Adding docker repository to dnf
    - Installing docker
    - Enable the installed docker and start its deamon
    - Adding $USER (root) and 'vagrant' to the docker group for working without need of sudo
    - Opening firewall ports for 8080/tcp, http, https and reload the firewall (take a note that the firewall is stop by default and have to be started, i am still it stop bc of some issues)
    - Checking the Ethernet interface
    - Craeting a folder on the virtual machine and copies the files we created earlier into the resource folder - index.html and Dockerfile
    - Pulling docker image
    - build image with name dockerhw and tag v0.0.1
    - Runs the container, from our image dockerhw:v0.0.1, in background (detach) with keeping STDIN open (i) and port forwarding 8080 on the host to 80 on the guest (-p 8080:80)
5. Open localhost:8080 from my machine and Voilà, we have it running..
