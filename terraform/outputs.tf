output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = [for instance in aws_instance.class : instance.public_ip]
}
