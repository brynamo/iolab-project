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
		$scope.course = Course.get({id: $routeParams.courseId}, () ->
			# Reformat old tags
			_.each($scope.course.tags, (tag) ->
				if tag.text?
					tag.tag = tag.text
					delete tag.text
			)
			
			# Start watching when course is initialized
			$scope.$watch('course.my_rating', (newValue, oldValue) -> 
				if newValue and newValue != oldValue
					## Send online
					console.log("Update rating")
					$scope.course.$update()
					
			)

		)
		console.log("Course", $scope.course)
		
		

		
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
