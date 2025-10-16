variable "alb_name" { type = string }
variable "subnets" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "tags" { 
    type = map(string) 
    default = { Project = "private-eks-webapp" } 
}
