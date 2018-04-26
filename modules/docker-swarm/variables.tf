# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "swarm_name" {
  description = "The name of the Docker swarm (e.g. docker-stage). This variable is used to namespace all resources created by this module."
}

variable "ami_id" {
  description = "The ID of the AMI to run in this swarm. Should be an AMI that had Docker installed and configured by the install-docker module."
}

variable "instance_type" {
  description = "The type of EC2 Instances to run for each node in the swarm (e.g. t2.micro)."
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the swarm"
}

variable "manager_user_data" {
  description = "A User Data script to execute while the server is booting."
}

variable "worker_user_data" {
  description = "A User Data script to execute while the server is booting."
}

variable "manager_size" {
  description = "The number of nodes to have in the swarm. We strongly recommend setting this to 3 or 5."
}

variable "worker_size" {
  description = "The number of nodes to have in the swarm. We strongly recommend setting this to 3 or 5."
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Docker"
  type        = "list"
  default     = []
}

variable "allowed_inbound_security_group_ids" {
  description = "A list of security group IDs that will be allowed to connect to Docker"
  type        = "list"
  default     = []
}

variable "subnet_ids" {
  description = "The subnet IDs into which the EC2 Instances should be deployed. You should typically pass in one subnet ID per node in the manager_size variable. We strongly recommend that you run Docker in private subnets. At least one of var.subnet_ids or var.availability_zones must be non-empty."
  type        = "list"
  default     = []
}

variable "availability_zones" {
  description = "The availability zones into which the EC2 Instances should be deployed. You should typically pass in one availability zone per node in the manager_size variable. We strongly recommend against passing in only a list of availability zones, as that will run Docker in the default (and most likely public) subnets in your VPC. At least one of var.subnet_ids or var.availability_zones must be non-empty."
  type        = "list"
  default     = []
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this swarm. Set to an empty string to not associate a Key Pair."
  default     = ""
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow SSH connections"
  type        = "list"
  default     = []
}

variable "allowed_ssh_security_group_ids" {
  description = "A list of security group IDs from which the EC2 Instances will allow SSH connections"
  type        = "list"
  default     = []
}

variable "swarm_tag_key" {
  description = "Add a tag with this key and the value var.swarm_name to each Instance in the ASG."
  default     = "Name"
}

variable "swarm_extra_tags" {
  description = "A list of additional tags to add to each Instance in the ASG. Each element in the list must be a map with the keys key, value, and propagate_at_launch"
  type = "list"
  #example: 
  # default = [
  #   {
  #     key = "Environment"
  #     value = "Dev"
  #     propagate_at_launch = true
  #   } 
  # ]
  default = []
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default."
  default     = "Default"
}

variable "associate_public_ip_address" {
  description = "If set to true, associate a public IP address with each EC2 Instance in the swarm. We strongly recommend against making Docker nodes publicly accessible, except through an ELB (see the docker-elb module)."
  default     = false
}

variable "tenancy" {
  description = "The tenancy of the instance. Must be one of: default or dedicated."
  default     = "default"
}

variable "root_volume_ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized."
  default     = false
}

variable "root_volume_type" {
  description = "The type of volume. Must be one of: standard, gp2, or io1."
  default     = "standard"
}

variable "root_volume_size" {
  description = "The size, in GB, of the root EBS volume."
  default     = 50
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "target_group_arns" {
  description = "A list of target group ARNs of Application Load Balanacer (ALB) targets to associate with this ASG. If you're using a Elastic Load Balancer (AKA ELB Classic), use the load_balancers variable instead."
  type        = "list"
  default     = []
}

variable "load_balancers" {
  description = "A list of Elastic Load Balancer (ELB) names to associate with this ASG. If you're using an Application Load Balancer (ALB), use the target_group_arns variable instead."
  type        = "list"
  default     = []
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

variable "health_check_type" {
  description = "Controls how health checking is done. Must be one of EC2 or ELB."
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time, in seconds, after instance comes into service before checking health."
  default     = 300
}

variable "instance_profile_path" {
  description = "Path in which to create the IAM instance profile."
  default     = "/"
}

variable "api_port" {
  description = "The port to use for Docker daemon calls"
  default     = 2375
}

variable "ssh_port" {
  description = "The port used for SSH connections"
  default     = 22
}