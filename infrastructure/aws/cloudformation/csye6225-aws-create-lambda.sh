echo "Please enter Serverless Stack Name:"
read appStackName
if [ -z "$appStackName" ]
then
	echo "StackName error exiting!"
	exit 1
fi
echo "$appStackName"
echo "Fetching domain name from Route 53"
DOMAIN_NAME=$(aws route53 list-hosted-zones --query HostedZones[0].Name --output text)
DOMAIN_NAME="${DOMAIN_NAME%?}"
echo "DOMAIN_NAME:- $DOMAIN_NAME"

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
LAMBDABUCKET="lambda-$DOMAIN_NAME"
=======
LAMBDABUCKET="code-deploy."${DOMAIN_NAME}
>>>>>>> 9d3fbe54fc9a371571e5006069d0281b6c758a69
=======
LAMBDABUCKET="code-deploy."${DOMAINNAME}
>>>>>>> 6269fc17ca52c9ecca5ebdbeab07fe4c19b1b68c
=======
LAMBDABUCKET="code-deploy."${DOMAIN_NAME}
>>>>>>> d36205d90d547c7df58b2f8b69cfad366bb287d9
echo "LAMBDA_BUCKET:- $LAMBDABUCKET"

AccountId=$(aws iam get-user|python -c "import json as j,sys;o=j.load(sys.stdin);print o['User']['Arn'].split(':')[4]")
echo "AccountId: $AccountId"

SNSTOPIC_ARN="arn:aws:sns:us-east-1:$AccountId:SNSTopicResetPassword"
echo "SNSTOPIC_ARN: $SNSTOPIC_ARN"

createres=$(aws cloudformation create-stack --stack-name $appStackName-serverless --capabilities "CAPABILITY_NAMED_IAM" --template-body file://csye6225-aws-cf-lambda.json --parameters ParameterKey=LAMBDABUCKET,ParameterValue=$LAMBDABUCKET ParameterKey=SNSTOPICARN,ParameterValue=$SNSTOPIC_ARN)
resp=$(aws cloudformation wait stack-create-complete --stack-name $appStackName-serverless)
if [[ -z "$resp" ]]; then
  echo Stack "$appStackName" sucessfully created
else
  echo "$resp"
  exit 1
fi
STACKDETAILS=$(aws cloudformation describe-stacks --stack-name $appStackName-serverless --query Stacks[0].StackId --output text)
