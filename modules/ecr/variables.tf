variable "name" { type = string }
variable "tags" { 
    type = map(string) 
    default = { Project = "private-eks-webapp" } 
}
