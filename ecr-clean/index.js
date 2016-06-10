#!/usr/local/bin/node

'use strict';

var Q = require('q');
var AWS = require('aws-sdk');
AWS.config.setPromisesDependency(Q.Promise);

var ecr = new AWS.ECR();

function deleteImages(repoName, imageDigests) {
	var imageIds = [],
		requestParams = {
			imageIds: imageIds,
			repositoryName: repoName
		};
	if (imageDigests.length === 0) {
		return;
	}
	imageDigests.forEach(function (digest) {
		imageIds.push({imageDigest: digest});
	});
	return ecr.batchDeleteImage(requestParams).promise();
}

function cleanRepo(repo) {
	return ecr.listImages({repositoryName: repo}).promise().then(function (data) {
		var imageDigests = [];
		data.imageIds.forEach(function (image) {
			if (!image.imageTag) {
				console.log('INFO: Found image without tag: ' + image.imageDigest + ' in repository ' + repo);
				imageDigests.push(image.imageDigest);
			} else {
				console.log('INFO: Image has tag: ' + image.imageTag + ' in repository ' + repo);
			}
		});
		return deleteImages(repo, imageDigests);
	});
}

exports.handler = function (event, context, callback) {
	console.log("INFO: request Received.\nDetails:\n", JSON.stringify(event));

	ecr.describeRepositories({}).promise().then(function (data) {
		var cleanJobs = [];
		data.repositories.forEach(function (repo) {
			console.log('INFO: Found repository: ' + repo.repositoryName);
			cleanJobs.push(cleanRepo(repo.repositoryName));
		});
		return Q.all(cleanJobs);
	}).then(function () {
		callback(null, 'Successfully cleaned ECR');
	}).fail(function (err) {
		console.log('ERROR: ', err, err.stack);
		callback(err);
	});
};
