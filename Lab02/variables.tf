# Subscription
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "application_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "primary_location" {
  type = string
}
