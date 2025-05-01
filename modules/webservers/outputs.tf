output "instance" {
    value       = aws_instance.myapp-instance.id
    description = "The ID of the EC2 instance"
}