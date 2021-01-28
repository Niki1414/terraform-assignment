# create bastion host for connecting private IP

resource "aws_instance" "my-instance" {
  ami                    = "${var.webservers_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sec_group.id}"]
  subnet_id              = "${aws_subnet.public.0.id}"
  key_name               = "${aws_key_pair.terraform-demo.key_name}"
  tags = {
    Name = "Bastion host"

  }
}
