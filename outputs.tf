output "alb_dns_name" {
  value       = aws_lb.demo.dns_name
  description = "The domain name of the load balancer"
}

output "key_pair_key_name" {
  description = "The key pair name."
  value       = module.key-pair.key_pair_key_name
}