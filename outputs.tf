output "ec2-public_key" {
    value       = module.myapp-webservers.instance.public_ip
    description = "The public IP address of the EC2 instance"
}
