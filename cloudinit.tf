data "template_file" "jenkins_init" {
  template = "${file("scripts/jenkins-init.sh")}"

  vars {
    DEVICE            = "${var.INSTANCE_DEVICE_NAME}"
    JENKINS_VERSION   = "${var.JENKINS_VERSION}"
    TERRAFORM_VERSION = "${var.TERRAFORM_VERSION}"
    DOCKER_USER       = "${var.DOCKER_USER}"
    DOCKER_PASSWORD   = "${var.DOCKER_PASSWORD}"
    AWS_ACCESS_KEY    = "${var.AWS_ACCESS_KEY}"
    AWS_SECRET_KEY    = "${var.AWS_SECRET_KEY}"
  }
}

data "template_cloudinit_config" "cloudinit_jenkins" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.jenkins_init.rendered}"
  }
}
