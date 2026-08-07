output "public_ips" {

  value = aws_instance.server[*].public_ip
  #return list of all instances

}