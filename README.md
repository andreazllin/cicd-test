# Quickstarter for Express TypeScript Backend

Express.js Backend with TypeScript and Guide to Setup EC2 Instances to run it with a CI/CD Pipeline

## Steps

0. Search and Replace `custom_app_name` with desired name
1. Setup EC2
2. Setup Pipeline

Remember to have [IAM Roles](https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-service-role.html) and [userdata script](scripts/user_data.sh) set on the EC2 instance and also add it in the right target group

You can change the running port by editing the unit file in the [userdata script](scripts/user_data.sh)

## Useful stuff

- Check ports using: `sudo lsof -i -P -n`
- Check services for unit files using: `systemctl list-units`

### Notes

Created to learn how to setup a CI/CD Pipeline on AWS using CodePipeline, CodeBuild and CodeDeploy.
