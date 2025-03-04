variable "server_config" {
  type = object({
    name = string,
    type = string
  })
  description = "This is sever config for sever create state"

  validation {
    condition     = length(var.server_config.name) > 7 && length(var.server_config.name) < 20
    error_message = "Server name must be between 7 and 20 words"
  }

  validation {
    condition = contains(["t2.micro", "t3a.micro"], var.server_config.type)
    error_message = "Must be either t2.micro or t3.micro"
  }
}

variable "create_instance" {
  type = bool
  description = "This block is create instace with variable"
  default = true
}