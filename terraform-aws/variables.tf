variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "terraformInstance"
}
variable "vpc_security_group_ids" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "sg-05ecd9cd5d2c51414"
}

