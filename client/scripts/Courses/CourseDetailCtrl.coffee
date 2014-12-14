'use strict'
angular.module('app.courses.details', [])
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
		
		

		$scope.$watch('course.my_rating', (newValue, oldValue) -> 
			if newValue and newValue is not oldValue
				## Send online
				console.log("Update rating")
				$scope.course.$update()
				$scope.hasRated = ($scope.course.my_rating != null)
		)

		$scope.onTagsChanged = (changedTag) ->
			console.log("Tags changed", changedTag, $scope.tags)
			$scope.course.$update()

		$scope.domainColor = courseUI.domainColor
		$scope.getDomain = courseUI.getDomain
		$scope.subjectName = courseUI.subjectName
		$scope.getRatingStars = courseUI.getRatingStars
		
		$scope.relatedCourses = []

		# Dummy populate
		$scope.$watch('course.subject_id', (newValue) ->
			if newValue?
				$scope.relatedCourses = [$scope.course]
		)
])
