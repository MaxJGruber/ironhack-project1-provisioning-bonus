aws ssm describe-instance-information --region eu-central-1
aws ssm start-session --target i-072fe14486aea4265 --region eu-central-1
aws sts get-caller-identity ansible-inventory -i inventory_aws_ssm.yaml --graph
