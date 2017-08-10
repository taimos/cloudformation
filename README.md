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
You can use them to peer the VPC and allow access from your instances.

* MongoDB-Cluster-${Name}-VPC - VPC
* MongoDB-Cluster-${Name}-RTB - RouteTable
* MongoDB-Cluster-${Name}-SubnetA - SubnetA
* MongoDB-Cluster-${Name}-SubnetB - SubnetB
* MongoDB-Cluster-${Name}-SG - SecurityGroup

## CoreOS Update Check

`https://s3.amazonaws.com/taimos-cfn-public/templates/coreos-update-check.yaml`

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=coreos-update-check&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/coreos-update-check.yaml)

Deploy AWS Lambda function to check for outdated CoreOS instances.

## Cloudwatch logs to SumoLogic

`https://s3.amazonaws.com/taimos-cfn-public/templates/logs-sumologic.yaml`

Template to use as substack to ship logs from a CloudWatch log group to SumoLogic

```
  LogShipper:
    Type: 'AWS::CloudFormation::Stack'
    Properties:
      Parameters:
        LogGroup: !Ref SomeCloudWatchLogGroup
        SumoLogicCollector: 'endpoint1.collection.eu.sumologic.com'
        SumoLogicToken: 'SomeBase64EncodedToken'
      TemplateURL: 'https://s3.amazonaws.com/taimos-cfn-public/templates/logs-sumologic.yaml'
```

## VPN Server

`https://s3.amazonaws.com/taimos-cfn-public/templates/vpn-server.yaml`

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=vpn-server&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/vpn-server.yaml)

Deploy a IPSec VPN server within its own VPC.

### Parameters

* DNSHost - the name of the server. This will be part of the hostnames of the node
* DNSDomain - the domain to use for the host
* InstanceType - The type of instance to use for the server
* VPNUsername - the username for the IPSec user
* VPNPassword - the password for the IPSec user
* VPNPhrase - the pre-shared key for the IPSec connection

### Outputs

* VPC - The VPC of the VPN server
* RouteTable - The VPC RouteTable
* SubnetA - The Subnet in AZ a
* SubnetB - The Subnet in AZ b
* SecurityGroup - The SecurityGroup of the server
* VPNServerAddress - The FQDN of the VPN server
  
### Exports

Some values are exported for Cross-stack referencing. 
You can use them to peer the VPC and allow access from your instances.

* VPN-Server-${DNSHost}-VPC - VPC
* VPN-Server-${DNSHost}-RTB - RouteTable
* VPN-Server-${DNSHost}-SubnetA - SubnetA
* VPN-Server-${DNSHost}-SubnetB - SubnetB
* VPN-Server-${DNSHost}-SG - SecurityGroup

## Taimos remote support

`https://s3.amazonaws.com/taimos-cfn-public/templates/support-access.yaml`

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/new?stackName=taimos-support-access&templateURL=https://s3.amazonaws.com/taimos-cfn-public/templates/support-access.yaml)

To grant us access to your AWS account for support, create a CloudFormation stack using this link. 
This will create an IAM role we can assume that grants us AdministratorAccess. 
You can limit the permissions by attaching a different policy to the IAM role `TaimosSupport`. 
Please send us the outputs of this stack.

# Tools to build it locally

* node / npm
* awscli