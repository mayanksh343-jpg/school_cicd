variable "aws_region" {

  default = "ap-south-1"
}
//ya saab default values ha real values tfvars ma ha
variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "AWS Key Pair Name"
}

variable "instance_count" {
  default = 1
}

variable "private_key_path" {
  default = "~/shellscript"
}