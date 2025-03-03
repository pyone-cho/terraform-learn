variable "server_name" {
  type        = string
  description = "This is request server name block"
  default     = "test-server"
  validation {
    condition     = length(var.server_name) > 7 && length(var.server_name) < 20
    error_message = "Server name must be between 7 and 20 words"
  }
}
