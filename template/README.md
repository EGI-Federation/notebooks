# Template directory for Notebooks deployment

This directory has all the files to get started with a new deployment of EGI
Notebooks on a site.

## terraform 

The terraform directory contains the terraform configuration to start a set of VMs at
the provider

## playbooks 

This directory contains the ansible playbooks that will configure kubernetes
on the VMs and the ones that configure the notebooks instance(s) with helm on 
top of that kubernetes.

## deployments

helm configuration for the different notebooks instances running on the kubernetes 
deployments
