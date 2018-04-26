# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "security_group_id" {
  description = "The ID of the security group to which we should add the Docker security group rules"
}

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Docker"
  type        = "list"
}

variable "allowed_inbound_security_group_ids" {
  description = "A list of security group IDs that will be allowed to connect to Docker"
  type        = "list"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "api_port" {
  description = "The port to use for Docker API calls"
  default     = 2375
}

variable "management_port" {
  description = "The port to use for Docker Manager node communication"
  default     = 2377
}

variable "network_discovery_port" {
  description = "TCP and UDP port for communication among nodes (container network discovery)"
  default     = 7946
}

variable "overlay_network_port" {
  description = "UDP port for overlay network traffic (container ingress networking)."
  default     = 4789
}