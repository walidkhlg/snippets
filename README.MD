# Terraform snippets
These [Terraform](https://terraform.io) snippets can be used to deploy ressources and test them using [AWSPEC](https://github.com/k1LoW/awspec).



## Getting started

### Prerequisites
[Install Terraform](https://www.terraform.io/intro/getting-started/install.html).

Install AWSPEC with gem.
```
gem install awspec
```
Install rake.
```
gem install rake
```
### Get AWS Credentials
Use the platform auth cli to get your AWS credentials .

Configure environment variables with the appropriate AWS profile and region. Example :
```
AWS_PROFILE=role-test
AWS_REGION=eu-west-1
```
### Deploying the stack

#### Configure variables
Modify the variables.tf file with the appropriate values for the modules variables .

Each module will deployed the following resources:
##### Module Application
![Screenshot](https://github.com/walidkhlg/snippets/tree/master/doc/autoscaling.png)

##### Module Database
![Screenshot](https://github.com/walidkhlg/snippets/tree/master/doc/database.png)

#### Module Serverless
![Screenshot](https://github.com/walidkhlg/snippets/tree/master/doc/lambda.png)
