variable "req_id" {
  type = string

  validation {
    condition = can(regex("^req-", var.req_id))
    error_message = "value"
  }
}

variable "additional_tags" {
  default     = {
    env = "test"
  }
  description = "Additional resource tags"
  type        = map(string)
}