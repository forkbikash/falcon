variable "key_name" {
  description = "The key name."
}

variable "public_key" {
  description = "The public key."
  sensitive   = true
}
