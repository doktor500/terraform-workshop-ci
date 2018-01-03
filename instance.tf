resource "aws_instance" "jenkins_instance" {
  ami                    = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type          = "${var.AWS_INSTANCE_TYPE}"
  subnet_id              = "${aws_subnet.main_public.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_securitygroup.id}"]
  key_name               = "${aws_key_pair.admin_key.key_name}"
  user_data              = "${data.template_cloudinit_config.cloudinit_jenkins.rendered}"

  tags {
    Name = "jenkins"
  }
}

resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = "${var.AWS_AVAILABILITY_ZONE}"
  size              = 20
  type              = "gp2"

  tags {
    Name = "jenkins-data"
  }
}

resource "aws_volume_attachment" "jenkins_data_attachment" {
  device_name  = "${var.INSTANCE_DEVICE_NAME}"
  volume_id    = "${aws_ebs_volume.jenkins_data.id}"
  instance_id  = "${aws_instance.jenkins_instance.id}"
  skip_destroy = true
}
