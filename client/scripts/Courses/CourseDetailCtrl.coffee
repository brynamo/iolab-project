'use strict'
angular.module('app.courses')
.config([
	'tagsInputConfigProvider'
	(tagsInputConfigProvider) ->
        tagsInputConfigProvider.setTextAutosizeThreshold(24)
])
.controller('courseDetailCtrl', [
	'$scope', '$routeParams', 'courseFilter', 'courseUI', 'Course', 'filterFilter', '$rootScope', 'logger'
	($scope, $routeParams, courseFilter, courseUI, Course, filterFilter, $rootScope, logger) -> 
		$scope.course = Course.get({id: $routeParams.courseId})
		console.log("Course", $scope.course)
		
		$scope.hasRated = false # Get from user info in future

		$scope.$watch('course.rating', (newValue, oldValue) -> 
			if newValue and oldValue
				console.log("Rate", newValue, oldValue)
				## Send online
				$scope.hasRated = true

		)

		$scope.tags = ["Tag 1", "Tag 2"];
		$scope.onTagsChanged = (changedTag) ->
			console.log("Tags changed", changedTag, $scope.tags)

		$scope.domainColor = courseUI.domainColor
		$scope.subjectName = courseUI.subjectName
		$scope.getRatingStars = courseUI.getRatingStars


		$scope.relatedCourses = []

		# Dummy populate
		$scope.$watch('course.subject_id', (newValue) ->
			if newValue?
				$scope.relatedCourses = [$scope.course]
		)
])
