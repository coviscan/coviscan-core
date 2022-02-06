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