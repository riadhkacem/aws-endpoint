variable "region_name" {
  type    = string
  default = "eu-central-1"
}
variable "backend_bucket_name" {
  type = string
}
variable "locks_table_name" {
  type = string
}