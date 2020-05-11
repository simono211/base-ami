# base-ami #

### Description ###

This repo will create base AMIs for running Jenkins build agents and various applications.

**What you'll need:**

  * packer
  * AWS user credentials that can create AMIs

**Scripted Pipelines**
Build Pipelines exist for the artifactory and build-agent AMI builds and are configured in the production Jenkins instance.

These Jenkinsfiles pull the Private keys from AWS Secrets manager at build time.

**Manual Steps:**

Validate the Packer configuration:
```
packer validate jenkins-agent-ami.json
```

Build the AMI(s):
```
./scripts/get_secret.sh base-ami
packer build base-ami.json

./scripts/get_secret.sh prod-artifactory
packer build artifactory.json

./scripts/get_secret.sh jenkins-build-agent
TF_VERSION=0.12.21 aws-vault exec prod -- packer build jenkins-agent-ami.json

aws-vault exec dev -- ./scripts/get_secret.sh jenkins-build-agent
TF_VERSION=0.12.21 aws-vault exec dev -- packer build \
  -var vpc_id=<vpc_id> \
  -var subnet_id=<subnet_id> \
  -var ssh_private_key_file=jenkins-build-agent \
  jenkins-agent-ami.json

aws-vault exec prod -- ./scripts/get_secret.sh prod-openvpn-as
aws-vault exec prod -- packer build openvpn-as.json

aws-vault exec prod -- ./scripts/get_secret.sh prod-sonarqube
packer build sonarqube.json
```

Example test instance creation:
```
# Jenkins Build Agent
aws ec2 run-instances --image-id *ami_id* --instance-type t3a.medium --key-name JenkinsBuildAgent --count 1 --subnet-id subnet-<id> --security-group-ids sg-<id> --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=jenkins-build-agent-test}]'
```

Terminate (destroy) test instances:

```
aws ec2 terminate-instances --instance-ids *instance_id*
```