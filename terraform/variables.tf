variable "domain_name" {
    type = string
}

variable "bucket_name" {
    type = string
}

variable "route53_hosted_zone_id" {
    type = map(string)
}