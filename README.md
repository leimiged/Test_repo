# Test_repo

In this repo, we have a Terraform code where you can create:

- 3 AWS VM's and we give them some tags names, 
- Table route, 
- Security group, 
- VPC, 
- Ready to be connected throught ssh command using key pair,
- And we install docker image in all VM's

With ansible code, we can:

- Use AWS plugin to manage the VM's separated by groups using ip and name tag, therefore we don´t need using the inventory or hosts files,
- We create an user in the local VM's
- We tranfer some files to the VM's,
- We install, Nginx Server,
- We instal, Apache server,
