# terraform-workshop-ci

### What you need:

- A laptop with Linux or Mac OS
- An active AWS account -> http://aws.amazon.com (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY)
- A Docker Hub account -> http://hub.docker.com (USERNAME and PASSWORD)

___

### Setup:

#### Install terraform (Mac OS X using brew)

	brew install terraform

#### Install terraform (Ubuntu Linux)

	sudo apt-get install unzip
	wget https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip
	sudo mv terraform /usr/local/bin/

#### Create the variables file

	touch terraform.tfvars

#### Edit the `terraform.tfvars` file with the following content (replacing the variables)

	AWS_ACCESS_KEY  = "$AWS_ACCESS_KEY"
	AWS_SECRET_KEY  = "$AWS_SECRET_KEY"
	S3_BUCKET = "terraform-workshop-ci-state-$USERNAME"
	DOCKER_USER = "$DOCKER_USER"
	DOCKER_PASSWORD = "$DOCKER_PASSWORD"

___

### Create the CI environment:

- Execute `terraform apply` and wait until the instance is initialized
- SSH `ubuntu@${jenkins_ip}`
- Execute `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` and take note of the password
- Navigate to `${jenkins_ip}:8080` and set the password
- Install Jenkins suggested plugins
- Continue as admin
- Create a `terraform-workshop-app` job (Freestyle project)
- Setup the github project (https://github.com/doktor500/terraform-workshop-app)
- Setup git repository (https://github.com/doktor500/terraform-workshop-app)
- Set Poll SCM schedule to `* * * * *`
- Add a new build step (Execute shell) with the following content `./jenkins.sh`
- Save the job
- Execute a new build
