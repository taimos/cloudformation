# Templates

## ECR Clean

`https://s3.amazonaws.com/taimos-cfn-public/templates/ecr-clean.yaml`

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=ecr-clean&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/ecr-clean.yaml)

Deploy AWS Lambda function to clean up untagged images from ECR.

## RollingUpdate notifier

`https://s3.amazonaws.com/taimos-cfn-public/templates/rolling-update-notifier.yaml`

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=rolling-update-notifier&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/rolling-update-notifier.yaml)

Deploy AWS Lambda function to signal CloudFormation when instances are marked as InService by ELB

### Usage

When creating an AutoScalingGroup attach a CloudWatch Rule that calls the lambda whenever a new instance is launched. 
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
        - Arn: !ImportValue RollingUpdateLambda
          Id: "TargetFunction"
```

## MongoDB Replica Set

`https://s3.amazonaws.com/taimos-cfn-public/templates/mongodb-cluster.yaml`

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=mongodb-cluster&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/mongodb-cluster.yaml)

Deploy a MongoDB ReplicaSet within its own VPC.

### Parameters

* Name - the name of the cluster. This will be part of the hostnames of the nodes
* Domain - the domain to use for the hosts
* NetPrefix - the first three bytes of the IP range (e.g. 10.0.0)
* InstanceType - The type of instance to use for the nodes

### Outputs

* VPC - The VPC of the MongoDB cluster
* RouteTable - The VPC RouteTable
* SubnetA - The Subnet in AZ a
* SubnetB - The Subnet in AZ b
* SecurityGroup - The SecurityGroup of the nodes
* NodeNames - The hostnames of the cluster nodes for database access
* ExternalNodeNames - The external hostnames of the cluster nodes for SSH access

### Exports

Some values are exported for Cross-stack referencing. 
You can use them to per the VPC and allow access from your instances.

* MongoDB-Cluster-${Name}-VPC - VPC
* MongoDB-Cluster-${Name}-RTB - RouteTable
* MongoDB-Cluster-${Name}-SubnetA - SubnetA
* MongoDB-Cluster-${Name}-SubnetB - SubnetB
* MongoDB-Cluster-${Name}-SG - SecurityGroup

## CoreOS Update Check

`https://s3.amazonaws.com/taimos-cfn-public/templates/coreos-update-check.yaml`

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=coreos-update-check&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/coreos-update-check.yaml)

Deploy AWS Lambda function to check for outdated CoreOS instances.

# Tools to build it locally

* node / npm
* cfn-include
* awscli
* jp