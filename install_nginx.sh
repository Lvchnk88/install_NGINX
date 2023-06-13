#!/bin/bash

info () {
    lgreen='\e[92m'
    nc='\033[0m'
    printf "${lgreen}[Info] ${@}${nc}\n"
}

error () {
    lgreen='\033[0;31m'
    nc='\033[0m'
    printf "${lgreen}[Error] ${@}${nc}\n"
}

#=======================================

GIT_REPO="/srv/TEAMinternational_Learning"

pre_install_nginx () {
#Install the prerequisites
    apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring  &> $log_path/tmp.log
    if [ $? -eq 0 ];
      then
            info "Install the prerequisites complete"
      else
            tail -n20 $log_path/tmp.log
            error "Install the prerequisites failed"
      exit 1
fi

#Import an official nginx signing key so apt could verify the packages authenticity. Fetch the key
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null  &> $log_path/tmp.log
    if [ $? -eq 0 ];
      then
            info "Import an official nginx signing key complete"
      else
            tail -n20 $log_path/tmp.log
            error "Import an official nginx signing key failed"
      exit 1
fi

#set up the apt repository for stable nginx packages
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list  &> $log_path/tmp.log
    if [ $? -eq 0 ];
      then
            info "set up the apt repository for stable nginx complete"
      else
            tail -n20 $log_path/tmp.log
            error "set up the apt repository for stable nginx failed"
      exit 1
fi
}

install_nginx () {
    sudo apt update
    sudo apt install nginx   &> $log_path/tmp.log
    if [ $? -eq 0 ];
      then
            info "install_nginx complete"
      else
            tail -n20 $log_path/tmp.log
            error "install_nginx failed"
      exit 1
fi
}

test_after_install () {
     nginx -t                &> $log_path/tmp.log

if [ $? -eq 0 ];
      then
            info "test_after_install complete"
      else
            tail -n20 $log_path/tmp.log
            error "test_after_install failed"
      exit 1
fi
}

replace_configs () {
    cp $GIT_REPO/nginx/nginx.conf   /etc/nginx/   &> $log_path/tmp.log
if [ $? -eq 0 ];
      then
            info "replace nginx.conf  complete"
      else
            tail -n20 $log_path/tmp.log
            error "replace nginx.conf  failed"
      exit 1
fi
}

test_after_configs () {
     nginx -t                 &> $log_path/tmp.log

if [ $? -eq 0 ];
      then
            info "test_after_configs complete"
      else
            tail -n20 $log_path/tmp.log
            error "test_after_configs failed"
      exit 1
fi
}

enable_nginx () {
     systemctl enable nginx     &> $log_path/tmp.log

if [ $? -eq 0 ];
      then
            info "enable_nginx complete"
      else
            tail -n20 $log_path/tmp.log
            error "enable_nginx failed"
      exit 1
fi
}

start_service () {
    systemctl restart nginx     &> $log_path/tmp.log

if [ $? -eq 0 ];
      then
            info "start_service complete"
      else
            tail -n20 $log_path/tmp.log
            error "start_service failed"
      exit 1
fi
}

main () {

pre_install_nginx

install_nginx

test_after_install

replace_configs

test_after_configs

enable_nginx

start_service

}

main
