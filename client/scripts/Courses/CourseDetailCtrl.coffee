'use strict'
angular.module('app.courses')

.controller('courseDetailCtrl', [
	'$scope', '$routeParams', 'courseFilter', 'Course', 'filterFilter', '$rootScope', 'logger'
	($scope, $routeParams, courseFilter, Course, filterFilter, $rootScope, logger) -> 
		$scope.course = Course.get({id: $routeParams.courseId})
		console.log("Course", $scope.course)		
])