resource "aws_iam_policy" "ec2" {
  name        = "${var.resource_name_prefix}_ec2"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateVpc", 
          "ec2:CreateSubnet", 
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateRouteTable", 
          "ec2:CreateRoute", 
          "ec2:CreateInternetGateway", 
          "ec2:AttachInternetGateway", 
          "ec2:AssociateRouteTable", 
          "ec2:ModifyVpcAttribute"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "ec2:DeleteInternetGateway",
        "Resource": "arn:aws:ec2:*:${local.account_id}:internet-gateway/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:ReplaceRoute",
          "ec2:DeleteRoute"
        ],
        "Resource": "arn:aws:ec2:*:${local.account_id}:route-table/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeSecurityGroups", 
          "ec2:DescribeSecurityGroupRules", 
          "ec2:DescribeVpcs"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:ModifySecurityGroupRules",
          "ec2:DeleteSecurityGroup" 
        ],
        "Resource": "arn:aws:ec2:*:${local.account_id}:security-group/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateSecurityGroup"
        ],
        "Resource": "arn:aws:ec2:*:${local.account_id}:security-group/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateTags"
        ],
        "Resource": "arn:aws:ec2:*:${local.account_id}:security-group/*"
      },
      {
      "Effect":"Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
        "ec2:ModifySecurityGroupRules"
      ],
      "Resource": "arn:aws:ec2:*:${local.account_id}:security-group/*",
        "Condition": {
          "ArnEquals": {
            "ec2:Vpc": "arn:aws:ec2:*:${local.account_id}:vpc/*"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": [
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSecurityGroupRules",
            "ec2:DescribeTags"
        ],
        "Resource": "*"
      },
      {  
         "Effect":"Allow",
         "Action":[  
            "ec2:CreateVpcEndpointServiceConfiguration",
            "ec2:DeleteVpcEndpointServiceConfigurations",
            "ec2:DescribeVpcEndpointServiceConfigurations",
            "ec2:ModifyVpcEndpointServicePermissions"
         ],
         "Resource":"*"
      },
      {  
         "Effect":"Allow",
         "Action":[  
            "elasticloadbalancing:DescribeLoadBalancers"
         ],
         "Resource":"*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_full" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ec2.arn
}