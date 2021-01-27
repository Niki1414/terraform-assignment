##creating key pair

resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("terraform-demo.pub")}"
}



## Creating Launch Configuration
resource "aws_launch_configuration" "launch_configuration" {
  # image_id               = "${lookup(var.amis,var.region)}"
  image_id        = "${var.webservers_ami}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.private_webserverss.id}"]
  user_data       = "${file("install_httpd.sh")}"
  key_name        = "${aws_key_pair.terraform-demo.key_name}"
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    encrypted             = true
    delete_on_termination = true
  }
  ebs_block_device {
device_name="/dev/sdf"
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
    encrypted             = true

  }

}
## Creating AutoScaling Group
resource "aws_autoscaling_group" "autoscaling_group" {
  #count                   = "${length(var.public_subnets_cidr)}"
  launch_configuration = "${aws_launch_configuration.launch_configuration.id}"
  vpc_zone_identifier  = aws_subnet.private.*.id
  #  availability_zones   = ["$var.azs"]
  min_size          = 2
  max_size          = 3
  load_balancers    = ["${aws_elb.terra-elb.name}"]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}
