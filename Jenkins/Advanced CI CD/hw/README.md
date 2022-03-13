## Homework M5: Jenkins Advanced

### Assignment
You are expected to create the following
1. A setup with two virtual machines – one with Jenkins and another with Docker installed just like on the practice
* You can adjust their parameters in order to fit within your available resources
2. On the Docker machine you must deploy Gitea (as we did during the practice)
    - Create a repository to host your version of the BGApp application
    - Enable Webhooks
3. On the Jenkins machine create a pipeline to build the BGApp application. There should be steps for:
    - Downloading the project from your Gitea repository
    - Using one Docker Compose file to
            - Build the images
            - Create a common network
            - Run the containers (the web container to publish port on 8080)
    - Testing the application for reachability and that (after a short wait) one of cities (for example Sofia) is displayed
    - Stopping the application and removing the containers
    - Publishing the images to Docker Hub
    - Using another Docker Compose file to
            - Create a common network
            - Run the containers (the web container to publish port on 80)
As usual, try to do the infrastructure part as automated as possible. Of course, using Vagrant
For the Jenkins part, try to automate it as much as possible. Ideally, there should be a Jenkinsfile hosted in the repository from which you create the pipeline (try to use the CLI to automate this as well)


### Tips for usage:
1. Clone the repository, and create the machines - open a terminal and execute `vagrant up`
    - Login to jenkins machine, jenkins user
        - create key `ssh-keygen -t rsa -m PEM`
        - copy the key to the jenkins host `ssh-copy-id jenkins@jenkins.m5.hw`
        - copy the key to the docker host `ssh-copy-id jenkins@docker.m5.hw`
2. Preparation Jenkins UI
    - Credentials (username: jenkins)
        - Add Credentials Username with password
        - Add Credentials SSH Username with private key (credentials from file), Enter directly 
            - paste the contents of the private key file which can be extracted (on the jenkins machine) with `sudo cat /var/lib/jenkins/.ssh/id_rsa`
    - Plugins
        - SSH
        - Blue Ocean
        - gitea
    - Hosts /Manage Jenkins => Configure System/ (SSH remote hosts / SSH sites)
        - hostname: `jenkins.m5.hw`
        - port: 22
        - credentials: jenkins (Credentials from file) or jenkins (Local user with password)
    - Slave Host /Manage Jenkins => Manage Nodes and Clouds => New Node/
        - node name: docker-node
        - Permanent Agent -> Create
        - Set number of executors to 4
        - Remote root dir: `/home/jenkins`
        - Enter docker-node in Labels
        - Usage: Only build jobs with label expression matching this node
        - Launch method: Launch slave agents via SSH
        - host: `docker.m5.hw`
        - credentials: jenkins (Credentials from file)
        - Host Key Verification Strategy: Known hosts file
    - Jenkins CLI
        - Configure Global Security 
            - set SSH Server to Fixed port `2222`
                - Test it from the jenkins machine: `curl -Lv http://192.168.56.11:8080/login 2>&1 | grep -i 'x-ssh-endpoint'`
        - Manage Users (admin)
            - Create public/private key for the vagrant user from jenkins machine `ssh-keygen`
            - Configurate admin user - set SSH Public Keys with the return value of `cat ~/.ssh/id_rsa.pub`
        - Test CLI from the jenkins machine terminal 
            - `ssh -l admin -p 2222 localhost help`
            - `ssh -l admin -p 2222 localhost version`
            - `ssh -l admin -p 2222 localhost who-am-i`
        - Web Hooks
            - 
    - Gitea Ui setup (http://192.168.56.12:3000)
        - Set Server Domain to 192.168.56.12
        - Set Gitea Base URL to http://192.168.56.12:3000/
        - Create an account
        - Create a "bgapp" repository clone from `https://github.com/ivelin1936/devops-bgapp.git`
        
            
