#!/bin/bash

SHARED_FOLDER=/node
CG_SCRIPT=clone_gitea_repo.sh
test -f $SHARED_FOLDER/$CG_SCRIPT && cp $SHARED_FOLDER/$CG_SCRIPT . && sudo chown vagrant:vagrant $CG_SCRIPT && sudo chmod +x $CG_SCRIPT

