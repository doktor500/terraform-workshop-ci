resource "aws_key_pair" "admin_key" {
  key_name   = "admin_key"
  public_key = "${file(var.SSH_PUBLIC_KEY_PATH)}"
}
