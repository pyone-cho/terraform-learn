variable "server_name" {
  type        = string
  description = "This block is request server name"
  validation {
    condition     = length(var.server_name) > 7 && length(var.server_name) < 20
    error_message = "Server name must be between 7 and 20 words"
  }
}
variable "server_type" {
  type = string
  description = "This block is Choosing server instance type"
  validation {
    condition = contains(["t2.micro", "t3a.micro"], var.server_type)
    error_message = "Must be either t2.micro or t3.micro"
  }
}


