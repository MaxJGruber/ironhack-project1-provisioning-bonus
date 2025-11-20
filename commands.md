aws ssm describe-instance-information --region eu-north-1
aws ssm start-session --target i-0c328fe9be2cfb8c9 --region eu-north-1
aws ssm start-session --target i-0aed89e641e91d4fb --region eu-north-1
aws ssm start-session --target i-0a7d5b72e002ab436 --region eu-north-1
aws sts get-caller-identity ansible-inventory -i inventory_aws_ssm.yaml --graph
