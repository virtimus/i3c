#!/bin/bash
#https://www.vagrantup.com/intro/getting-started/project_setup.html
cd /data
mkdir vagrant_getting_started
cd vagrant_getting_started
vagrant init


#vagrant box add hashicorp/precise64
vagrant box add tknerr/baseimage-ubuntu-14.04 
