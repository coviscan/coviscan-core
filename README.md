# coviscan-core
This repo includes the the backend cloud infrastructure and dcc-validation-decorator

## Set up AWS authentication

you have to export the follwing env var

```bash
export AWS_PROFILE=coviscan
```

## Set up Google cloud default project

set the default project env var

```bash
export GOOGLE_PROJECT=coviscan-339716
```

## Setup OIDC provider for Github in AWS

see links:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

Add AWS role in IAM with trust relationship like

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::161247518108:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:coviscan/coviscan-core:*"
                }
            }
        }
    ]
}
```

### Bootstrapping the AWS IAM roles

In order to initially create all IAM roles that you need to assume in Github actions you need one bootstrap user with AWS credentials that has the following policies attached:

* IAMFullAccess (In order to create the IAM roles)
* AmazonS3FullAccess (In order to initiate the Terraform S3 backend)
* A custom role with all OIDC permissions allowing the following actions
    * iam:RemoveClientIDFromOpenIDConnectProvider
    * iam:ListOpenIDConnectProviderTags
    * iam:UpdateOpenIDConnectProviderThumbprint
    * iam:UntagOpenIDConnectProvider
    * iam:AddClientIDToOpenIDConnectProvider
    * iam:DeleteOpenIDConnectProvider
    * iam:GetOpenIDConnectProvider
    * iam:TagOpenIDConnectProvider
    * iam:CreateOpenIDConnectProvider

After setting up the initial bootstrap user you have to execute the bootstraping script

```bash
bash /bin/tf/aws/bootstrap_create_iam_roles.sh 
```

## Load testing

We are load testing using [k6](https://k6.io/) from Grafana Labs. For installation instructions see [here](https://k6.io/docs/getting-started/installation/).