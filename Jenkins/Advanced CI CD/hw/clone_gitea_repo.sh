#!/bin/bash

echo Source repo:
read FROM_URL
[ -z "$FROM_URL" ] && FROM_URL=https://github.com/venceslav82/devops-bgapp.git

echo Username:
read USERNAME
[ -z "$USERNAME" ] && USERNAME=douser

echo Password:
read PASSWORD
[ -z "$PASSWORD" ] && PASSWORD=Password1

basename=$(basename $FROM_URL)
REPO=${basename%.*}

git clone $FROM_URL
cd $REPO/ && rm -rf .git
#REPO=$(basename $PWD)
HOSTNAME_IP=$(hostname -i | awk '{print $2}')
[ -z "$HOSTNAME_IP" ] && HOSTNAME_IP=$(hostname -i | awk '{print $1}')

git init && git remote add origin http://$HOSTNAME_IP:3000/$USERNAME/$REPO.git
git add . && git commit -m 'initial commit'
git push http://$USERNAME:$PASSWORD@$HOSTNAME_IP:3000/$USERNAME/$REPO.git --all

[[ $(basename $PWD) == $REPO ]] && cd .. && rm -rf $REPO || [ -d $REPO ] &&  rm -rf $REPO
