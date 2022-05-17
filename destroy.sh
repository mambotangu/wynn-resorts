#!/bin/bash
clear

destroy_step_5 () {
  terraform -chdir=5-wsi init
  terraform -chdir=5-wsi destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 5"
    exit 1
  else
    echo "wsi resources destroyed. "
    rm -rf ./5-wsi/.terraform*
  fi

  echo "" > ./5-wsi/provider.tf
  destroy_step_4;
}

destroy_step_4() {
  terraform -chdir=4-wr init
  terraform -chdir=4-wr destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 4"
    exit 1
  else
    echo "WR resources destroyed. "
    rm -rf ./4-wr/.terraform*
  fi

  echo "" > ./4-wr/provider.tf
  destroy_step_3
}

destroy_step_3 () {
  terraform -chdir=3-shared init
  terraform -chdir=3-shared destroy --auto-approve -var-file=terraform.tfvars

  if [ $? != 0 ]; then
    echo "Error on step 3"
    exit 1
  else
    echo "Shared resources destroyed. "
    rm -rf ./3-shared/.terraform*
  fi

  echo "" > ./3-shared/provider.tf
  destroy_step_2
}

destroy_step_2() {
  terraform -chdir=2-organization init
  terraform -chdir=2-organization destroy --auto-approve -var-file=terraform.tfvars;

  if [ $? != 0 ]; then
    echo "Error on step 2"
    exit 1
  else
    echo "Organization resources destroyed. ";
    rm -rf ./2-organization/.terraform*;
  fi

  echo "" > ./2-organization/provider.tf;
  destroy_step_1;
}

destroy_step_1() {
  echo "" > ./1-bootstrap/provider.tf;

  terraform -chdir=1-bootstrap init -force-copy;

  if [ $? != 0 ]; then
    echo "Error on step 1 migrating state";
    exit 1
  else
    echo "Bootstrap state migrated. Destroying resources... ";
  fi

  terraform -chdir=1-bootstrap destroy -var-file=terraform.tfvars --auto-approve;

  if [ $? != 0 ]; then
    echo "Error on step 1";
    exit 1
  else
    echo "Bootstrap resources destroyed. ";
    rm -rf ./1-bootstrap/.terraform*;
    rm -f ./1-bootstrap/terraform.tfstate*;
  fi
  destroy_step_0;
}

destroy_step_0() {
  # Destroy the Workspace project
  if [[ $(uname -a | grep -i 'Linux cs') ]]
  then
    echo "*** CloudShell detected"
    GCP_WS_PROJECT_ID=$(gcloud projects list | grep foundation-workspace | grep PROJECT_ID | awk 'NR==1 {print $2}')
  else
    echo "*** Not running in CloudShell"
    GCP_WS_PROJECT_ID=$(gcloud projects list | grep foundation-workspace | awk 'NR==1 {print $1}')  
  fi
  #
  echo
  echo Deleting Workspace Foundation project
  echo
  gcloud projects delete $GCP_WS_PROJECT_ID --quiet
  # Delete the service acocunt keys associated wit the foundations workspace project service account. 
  rm sa-admin-caller.p12
  #
}

# Determine which step to destroy from
if [ -z $1 ] || [ $1 == 5 ]; then
  destroy_step_5;
fi

if [ $1 == 4 ]; then
  destroy_step_4;
fi

if [ $1 == 3 ]; then
  destroy_step_3;
fi

if [ $1 == 2 ]; then
  destroy_step_2;
fi

if [ $1 == 1 ]; then
  destroy_step_1;
fi

if [ $1 == 0 ]; then
  destroy_step_0;
fi
