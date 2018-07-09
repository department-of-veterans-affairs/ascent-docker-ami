# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP RULES THAT CONTROL WHAT TRAFFIC CAN GO IN AND OUT OF A DOCKER CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "allow_api_inbound_from_cidr_blocks" {
  count       = "${length(var.allowed_inbound_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.api_port}"
  to_port     = "${var.api_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_inbound_cidr_blocks}"]

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_inbound_tcp_from_monitor_server" {
  count       = "${length(var.allowed_monitor_cidr_blocks) >= 1 ? 1 : 0}"
  type      = "ingress"
  from_port = "${var.monitor_port}"
  to_port   = "${var.monitor_port}"
  protocol  = "tcp"
  cidr_blocks = ["${var.allowed_monitor_cidr_blocks}"]
   
  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_api_inbound_from_security_group_ids" {
  count                    = "${length(var.allowed_inbound_security_group_ids)}"
  type                     = "ingress"
  from_port                = "${var.api_port}"
  to_port                  = "${var.api_port}"
  protocol                 = "tcp"
  source_security_group_id = "${element(var.allowed_inbound_security_group_ids, count.index)}"

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_management_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.management_port}"
  to_port   = "${var.management_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_discovery_inbound_tcp_from_self" {
  type      = "ingress"
  from_port = "${var.network_discovery_port}"
  to_port   = "${var.network_discovery_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_discovery_inbound_udp_from_self" {
  type      = "ingress"
  from_port = "${var.network_discovery_port}"
  to_port   = "${var.network_discovery_port}"
  protocol  = "udp"
  self      = true

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_overlay_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.overlay_network_port}"
  to_port   = "${var.overlay_network_port}"
  protocol  = "udp"
  self      = true

  security_group_id = "${var.security_group_id}"
}

