resource "aws_security_group" "cf_ip" {
  count = var.CREATE_WEB_SG ? 1 : 0
  description = "CF ip for web instance security group"
  name        = format("%s-cf-ip", var.PROJECT_NAME)
  vpc_id      = var.VPC_ID

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "104.16.0.0/13", "108.162.192.0/18", "141.101.64.0/18", "162.158.0.0/15", "172.64.0.0/13", "173.245.48.0/20", "188.114.96.0/20", "190.93.240.0/20", "197.234.240.0/22", "198.41.128.0/17", "104.24.0.0/14"]
    description = "Cloudflare IPv4"
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "104.16.0.0/13", "108.162.192.0/18", "141.101.64.0/18", "162.158.0.0/15", "172.64.0.0/13", "173.245.48.0/20", "188.114.96.0/20", "190.93.240.0/20", "197.234.240.0/22", "198.41.128.0/17", "104.24.0.0/14"]
    description = "Cloudflare IPv4"
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }
}

resource "aws_security_group" "web_instance" {
  description = "web instance security group"
  name        = format("%s-web_instance", var.PROJECT_NAME)
  vpc_id      = var.VPC_ID

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "443"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = "443"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "80"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = "80"
  }

  ingress {
    cidr_blocks = [""]
    description = "Allow SSH from VPN"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = [""]
    description = "Allow SSH from jenkins"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = [""]
    description = "Allow SSH from VPN"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = [""]
    description = "FPle Zabbix"
    from_port   = "10050"
    protocol    = "tcp"
    self        = "false"
    to_port     = "10050"
  }
}

resource "aws_security_group" "rds_sg" {
  description = "RDS Default security group"
  name        = format("%s-rds-sg", var.PROJECT_NAME)
  vpc_id      = var.VPC_ID

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = [""]
    description = "Allow 3306 from Control-Master"
    from_port   = "3306"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3306"
  }

  ingress {
    cidr_blocks = [""]
    description = "Allow 3306 from VPN"
    from_port   = "3306"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3306"
  }

  ingress {
    cidr_blocks = [""]
    description = "Allow 3306 from VPN"
    from_port   = "3306"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3306"
  }

  ingress {
    cidr_blocks = [""]
    description = "FPle Zabbix"
    from_port   = "10050"
    protocol    = "tcp"
    self        = "false"
    to_port     = "10050"
  }

  ingress {
    security_groups = [aws_security_group.web_instance.id]
    description     = "connection from App"
    from_port       = "3306"
    protocol        = "tcp"
    self            = "false"
    to_port         = "3306"
  }
}


resource "aws_security_group" "efs_sg" {
  description = "EFS Default security group"
  name        = format("%s-efs-sg", var.PROJECT_NAME)
  vpc_id      = var.VPC_ID

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "TEMPORARY permission for EFS - please FIX THIS"
    from_port   = "2049"
    protocol    = "tcp"
    self        = "false"
    to_port     = "2049"
  }

}

resource "aws_security_group" "elastic_redis" {
  description = "allow connection tp redis port 6379"
  name        = format("%s-redis", var.PROJECT_NAME)
  vpc_id      = var.VPC_ID

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    security_groups = [aws_security_group.web_instance.id]
    description     = "allow connection to redis on port 6379"
    from_port       = "6379"
    protocol        = "tcp"
    self            = "false"
    to_port         = "6379"
  }

}

output "sg_cf_id" {
  value = aws_security_group.cf_ip.*.id
}

output "sg_redis_id" {
  value = aws_security_group.elastic_redis.id
}

output "sg_rds_id" {
  value = aws_security_group.rds_sg.id
}
output "sgweb_id" {
  value = aws_security_group.web_instance.id
}
