locals {
  agent_cidrs = [
    for ip in split(",", data.aws_ssm_parameter.agent_ips.value):
      "${ip}/32"
  ]
}

resource "aws_security_group" "lb-sg" {
    name        = "${var.environment}-${var.component_name}-lb-sg"
    description = "controls access to the ALB"
    vpc_id      = aws_vpc.main-vpc.id

    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = concat(["10.0.0.0/8"],
          split(",", data.aws_ssm_parameter.inbound_ips.value),
          local.agent_cidrs)
    }

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = concat(["10.0.0.0/8"],
          split(",", data.aws_ssm_parameter.inbound_ips.value),
          local.agent_cidrs)
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.environment}-${var.component_name}-lb-sg"
    }
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs-tasks-sg" {
    name        = "${var.environment}-${var.component_name}-ecs-tasks-sg"
    description = "allow inbound access from the ALB only"
    vpc_id      = aws_vpc.main-vpc.id

    ingress {
        protocol        = "tcp"
        from_port       = "5000"
        to_port         = "5000"
        security_groups = [aws_security_group.lb-sg.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.environment}-${var.component_name}-ecs-tasks-sg"
    }
}
