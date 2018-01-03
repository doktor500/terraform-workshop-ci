variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AWS_AVAILABILITY_ZONE" {
  default = "eu-west-1a"
}

variable "AWS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "SSH_USER" {
  default = "ubuntu"
}

variable "SSH_PUBLIC_KEY_PATH" {
  default = "~/.ssh/id_rsa.pub"
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}

variable "JENKINS_VERSION" {
  default = "2.89.2"
}

variable "TERRAFORM_VERSION" {
  default = "0.11.1"
}

variable "AMIS" {
  type = "map"

  default = {
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "AWS_ACCESS_KEY" {
  description = "The AWS access key."
}

variable "AWS_SECRET_KEY" {
  description = "The AWS secret key."
}

variable "S3_BUCKET" {
  description = "S3 Bucket"
}

variable "DOCKER_USER" {
  description = "Docker user"
}

variable "DOCKER_PASSWORD" {
  description = "Docker password"
}
