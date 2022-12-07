resource "aws_instance" "Demo_EC2" {
    ami           = var.ami
    instance_type = var.instance_size
    subnet_id     = var.subnet_id
    Security_groups = [var.security_group_id]

    tags = {
    Name =  "${var.project_name}-Ec2-${var.environment}"
    Environment = var.environment
}

}
