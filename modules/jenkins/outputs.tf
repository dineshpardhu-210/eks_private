output "jenkins_instance_id" {
  description = "ID of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.id
}

output "jenkins_private_ip" {
  description = "Private IP of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.private_ip
}

output "jenkins_sg_id" {
  description = "Security group ID used for Jenkins"
  value       = aws_security_group.jenkins.id
}
