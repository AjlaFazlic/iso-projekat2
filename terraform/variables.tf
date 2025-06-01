variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Availability zone for EC2 and EBS"
  type        = string
  default     = "us-east-1a"
}

variable "project_name" {
  description = "Iso-projekat2"
  type        = string
}

variable "key_name" {
  description = "EC2"
  type        = string
}

variable "instance_type" {
  description = "Tip EC2 instance"
  type        = string
  default     = "t2.micro"
}

