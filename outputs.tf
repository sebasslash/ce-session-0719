output "random_int_suffix" {
  value =  random_integer.suffix.id
  description = "The name of the bucket storing our statefile. Use this value in your S3 backend configuration."
}
