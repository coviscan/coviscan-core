aws_region = "eu-central-1"
resource_name_prefix = "coviscan"
environment         = "dev"
aws_ecr_repository_name = "dcc-validation-decorator"
availability_zones  = ["eu-central-1a", "eu-central-1b"]
private_subnets     = ["10.0.0.0/20", "10.0.32.0/20"]
public_subnets      = ["10.0.16.0/20", "10.0.48.0/20"]
tsl_certificate_arn = "arn:aws:acm:eu-central-1:161247518108:certificate/631ba7e5-4fac-4b1b-95ce-c06afb1ce451"
container_memory    = 512
container_image     = "161247518108.dkr.ecr.eu-central-1.amazonaws.com/dcc-validation-decorator"