# Templates

## ECR Clean

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=ecr-clean&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/ecr-clean.template)

Deploy AWS Lambda function to clean up untagged images from ECR.

## RollingUpdate notifier

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=rolling-update-notifier&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/rolling-update-notifier.yaml)

Deploy AWS Lambda function to signal CloudFormation when instances are marked as InService by ELB

### Usage

When creating an AutoScalingGroup attach a CloudWatch Rule that call the lambda whenever a new instance in launched. 
The lambda will then wait for the instance to be marked as InService and will call signalResource for the given ASG.

Example Rule:
```
ASGLaunchRule:
    Type: 'AWS::Events::Rule'
    Properties:
      Description: "Rule to notify lambda function for CFN signalling"
      EventPattern:
        source:
          - 'aws.autoscaling'
        detail-type:
          - 'EC2 Instance Launch Successful'
        detail:
          AutoScalingGroupName:
            - !Ref AutoScalingGroup
      State: "ENABLED"
      Targets:
        - Arn: <ARN of the deployed lambda>
          Id: "TargetFunction"
```

# Tools to build it locally

* node / npm
* cfn-include
* awscli
* jp