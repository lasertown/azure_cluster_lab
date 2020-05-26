# Requires the latest Terraform and Ansible
Azure Cloudshell has both Terraform and Ansible preinstalled, so cloning and launching from Cloudshell is convienent.
# Clone the repository and run this command from root of project folder:
$ ansible-playbook -i hosts lab.yml

The first run of the playbook will error since a bastion host with a public IP will need to be created, which the playbook will not have on the first run.