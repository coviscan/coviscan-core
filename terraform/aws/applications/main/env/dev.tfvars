aws_region = "eu-central-1"
resource_name_prefix = "coviscan"
stage_suffix = "${terraform.workspace == "prod" ? "" : -terraform.workspace}"
deployment = "coviscan-deployment${stage_suffix}"
service_name = "coviscan-service${stage_suffix}"
cluster = "coviscan-cluster${stage_suffix}"
task_definition=jsonencode([
  {
    name      = "dcc-validation-decorator"
    image     = "161247518108.dkr.ecr.eu-central-1.amazonaws.com/dcc-validation-decorator:latest"
    cpu       = 10
    memory    = 512
    essential = true
    portMappings = [
      {
        containerPort = 8080
        hostPort      = 8080
      }
    ]
  }
])