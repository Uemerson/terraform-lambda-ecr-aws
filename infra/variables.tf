variable "ecr_repository_name" {
    type = string
}

variable "lambda_name" {
    type = string
}

variable "lambda_timeout" {
    type    = number
    default = 3
}

variable "lambda_memory" {
    type = number
    default = 128
}