resource "aws_security_group" "webservers" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = "${aws_vpc.terra_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_webserverss" {
  name        = "allow_http_elb"
  description = "Allow http inbound traffic frpm elb"
  vpc_id      = "${aws_vpc.terra_vpc.id}"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = ["${aws_security_group.webservers.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_sec_group" {
  name        = "allow_ssh_from_everywhere"
  description = "Allow http inbound traffic frpm elb"
  vpc_id      = "${aws_vpc.terra_vpc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
