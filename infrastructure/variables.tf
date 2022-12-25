variable "telegram_production_env" {
  description = "Location of telegram_production.env"
  type        = string
  default     = "./telegram_production.env"
}

variable "user_interface_production_env" {
  description = "Location of user_interface_production.env"
  type        = string
  default     = "./user_interface_production.env"
}

variable "users_production_env" {
  description = "Location of users_production.env"
  type        = string
  default     = "./users_production.env"
}

variable "user_management_production_env" {
  description = "Location of user_management_production.env"
  type        = string
  default     = "./user_management_production.env"
}

variable "orders_production_env" {
  description = "Location of orders_production.env"
  type        = string
  default     = "./orders_production.env"
}

variable "payments_production_env" {
  description = "Location of payments_production.env"
  type        = string
  default     = "./payments_production.env"
}

variable "orders_management_production_env" {
  description = "Location of orders_management_production.env"
  type        = string
  default     = "./orders_management_production.env"
}

variable "notifications_production_env" {
  description = "Location of notifications_production.env"
  type        = string
  default     = "./notifications_production.env"
}

variable "bidding_production_env" {
  description = "Location of bidding_production.env"
  type        = string
  default     = "./bidding_production.env"
}

variable "user_url" {
  description = "URL of user service"
  type        = string
  default     = "http://3.135.214.65:8000/api/v1/user"
}

variable "payments_url" {
  description = "URL of payments service"
  type        = string
  default     = "http://3.135.214.65:3000"
}

variable "orders_url" {
  description = "URL of orders service"
  type        = string
  default     = "http://3.135.214.65:5002"
}

variable "user_management_url" {
  description = "URL of user management composite service"
  type        = string
  default     = "http://3.135.214.65:5000"
}

variable "orders_management_url" {
  description = "URL of user orders composite service"
  type        = string
  default     = "http://3.135.214.65:5003"
}

variable "bids_url" {
  description = "URL of bidding service"
  type        = string
  default     = "http://3.135.214.65:5077"
}
