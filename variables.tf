variable "project_name" {
    type = string
}

variable "region" {
    type = string
    description = "(optional) describe your variable"
}


variable "privatekeypath" {
    type = string
    default = "C:/Users/sai/.ssh/id_rsa."
}

variable "publickeypath" {
    type = string
    default = "C:/Users/sai/.ssh/id_rsa.pub."
}

variable "user" {
    type = string
    default = "sai"
}
