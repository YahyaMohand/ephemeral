variable "project" {
  type        = string
  description = "Project name"
  default     = "dz-eph"

  validation {
    condition     = var.project == "dz-eph"
    error_message = "\"Project name\" doesn't match the predefined value"
  }
}

variable "environment" {
  type    = string
  default = null
  description = "The environment (e.g., dev, staging, prod)"
}

variable "pr_number" {
  description = "The PR number for dynamic naming"
  type        = string
}

variable "is_backend" {
  description = "Whether to deploy backend resources"
  type        = bool
  default     = false
}

variable "is_frontend" {
  description = "Whether to deploy frontend resources"
  type        = bool
  default     = false
}


variable "apply_immediately" {
  type = bool
  description = "value of apply immediately for DocumentDB"
  default = true
}


variable "region" {
  type        = string
  description = "AWS region name"
  default     = "me-south-1"
}

variable "profile" {
  type        = string
  description = "AWS CLI profile name"
  default     = null
}

variable "account_id" {
  type        = string
  description = "AWS account Id"
  default     = "920373006270"

  validation {
    condition     = length(var.account_id) == 12
    error_message = "\"Account Id\" has wrong format"
  }
}


##################################################################
#                   CDN
##################################################################
variable "cdn_minimum_ssl_protocol" {
  type    = string
  default = "TLSv1.2_2021"

  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
}

##################################################################
#                   WAF
##################################################################
variable "addresses_to_be_whitelisted" {
  type        = list(string)
  description = "The list of IPs to be whitelisted"
  default     = []
}

variable "external_domain" {
  type = string
}

