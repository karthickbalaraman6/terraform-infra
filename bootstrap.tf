aws s3api create-bucket --bucket my-unique-terraform-state-bucket --region us-east-1 --create-bucket-configuration LocationConstraint=us-east-1


aws dynamodb create-table --table-name terraform-locks \
--attribute-definitions AttributeName=LockID,AttributeType=S \
--key-schema AttributeName=LockID,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region us-east-1