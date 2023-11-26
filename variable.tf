variable "region" {
  default = "us-east-1"
}

variable "ami" {
    default = "ami-0230bd60aa48260c6"  
}

variable "instance-type" {
  default = "t2.micro"
}

variable "key" {
  default = "demo"
}

variable "vpc-cidr" {
default = "10.10.0.0/16"  
}

variable "subnet1-cidr" {
  default = "10.10.1.0/24"
}

variable "subnet2-cidr" {
  default = "10.10.2.0/24"
}

variable "subnet-az" {
  default = "us-east-1a"
}
variable "subnet-az-2" {
  default = "us-east-1b"
}
variable "route-cidr" {
 default =  "0.0.0.0/0" 
}