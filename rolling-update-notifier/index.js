'use strict';

var Q = require('q');
var AWS = require('aws-sdk');
AWS.config.setPromisesDependency(Q.Promise);

var awsRegion = process.env.AWS_REGION;

var autoscaling = new AWS.AutoScaling({region: awsRegion});
var elb = new AWS.ELB({region: awsRegion});
var cloudformation = new AWS.CloudFormation({region: awsRegion});

function parseRequest(event) {
  var data = {};
  data.asgName = event.detail.AutoScalingGroupName;
  data.instanceId = event.detail.EC2InstanceId;
  return Q.resolve(data);
}

function fetchASGDetails(data) {
  var params = {
    AutoScalingGroupNames: [
      data.asgName
    ]
  };
  return autoscaling.describeAutoScalingGroups(params).promise().then(function (res) {
    var asg = res.AutoScalingGroups[0];
    
    asg.Tags.forEach(function (tag) {
      if (tag.Key === 'aws:cloudformation:logical-id') {
        data.logicalName = tag.Value;
      } else if (tag.Key === 'aws:cloudformation:stack-name') {
        data.stackName = tag.Value;
      }
    });
    if (asg.LoadBalancerNames && asg.LoadBalancerNames.length > 0) {
      data.elbName = asg.LoadBalancerNames[0];
      console.log('INFO: Found load balancer', data.elbName, 'for auto scaling group', data.asgName);
      return data;
    }
    return Q.reject('Did not find ELB for group', data.asgName);
  });
}

function waitForInstanceToBeInService(data) {
  console.log('INFO: Waiting for instance', data.instanceId, 'to be InService');
  var params = {
    LoadBalancerName: data.elbName,
    Instances: [
      {
        InstanceId: data.instanceId
      }
    ]
  };
  return elb.describeInstanceHealth(params).promise().then(function (info) {
    if (info.InstanceStates && info.InstanceStates.length === 1 && info.InstanceStates[0].State === 'InService') {
      console.log('INFO: Instance', data.instanceId, 'has reached InService');
      return data;
    } else {
      return Q.delay(data, 5000).then(waitForInstanceToBeInService);
    }
  });
}

function signalStackResource(data) {
  var params = {
    LogicalResourceId: data.logicalName,
    StackName: data.stackName,
    Status: 'SUCCESS',
    UniqueId: data.instanceId
  };
  return cloudformation.signalResource(params).promise().then(function (res) {
    return res;
  });
}

exports.handler = function (event, context, callback) {
  console.log("INFO: request Received.\nDetails:\n", JSON.stringify(event));
  
  parseRequest(event)
    .then(fetchASGDetails)
    .then(waitForInstanceToBeInService)
    .then(signalStackResource)
    .then(function (data) {
      callback(null, data);
    })
    .fail(function (err) {
      console.log('ERROR: ', err, err.stack);
      callback(null, err);
    });
};
