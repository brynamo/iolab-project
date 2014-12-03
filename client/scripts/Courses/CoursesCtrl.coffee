'use strict'
angular.module('app.courses', [])

.service('courseFilter', [
	() ->
		filter = {}
		return {
			getTopics: () -> 
				[
					{id: 1, name: "Biology & Life Sciences", color: "warning"}
					{id: 2, name: "Computer Science: Theory", color: "success"}
					{id: 3, name: "Mathematics", color: "danger"}
					{id: 4, name: "Law", color: "info"}
					{id: 5, name: "Chemistry", color: "primary"}
				]
			setFilter: (filter) ->
				filter =
					domain: filter.domain
					topic: filter.domain
					level: filter.domain
			getFilter: () ->
				return filter
		}
])

.controller('courseFilterCtrl', [
	'$scope', '$location', 'courseFilter', 'Course', 'filterFilter', '$rootScope', 'logger'
	($scope, $location, courseFilter, Course, filterFilter, $rootScope, logger) -> 
		
		calcCurrentStep = () ->
			if $scope.courseFilter.topic
				return 3
			if $scope.courseFilter.domain
				return 2
			return 1

		$scope.courseFilter = courseFilter.getFilter()
		$scope.currentStep = calcCurrentStep()


		$scope.topics = courseFilter.getTopics()

		$scope.$watchCollection('[courseFilter.domain, courseFilter.topic, courseFilter.level]', (newValues, oldValues) ->
			$scope.currentStep = Math.max($scope.currentStep, calcCurrentStep())

		)

		$scope.$watch('courseFilter.level', (newValue, oldValue) -> 
			if newValue != oldValue
				courseFilter.setFilter($scope.courseFilter)
				$location.path("/courses")
		)



])


.controller('courseBrowseCtrl', [
	'$scope', 'courseFilter', 'Course', 'filterFilter', '$rootScope', 'logger'
	($scope, courseFilter, Course, filterFilter, $rootScope, logger) -> 
		$scope.courses = Course.query()
		
		$scope.topics = courseFilter.getTopics()
		$scope.courseFilter = courseFilter.getFilter()

		$scope.topicColor = (topicId) -> 
			return $scope.topics[topicId].color

		$scope.topicName = (topicId) ->
			return $scope.topics[topicId].name

		$scope.getRatingStars = (rating) ->
			return (Array(rating + 1).join "\u2605") + (Array(5 + 1-rating).join "\u2606")

		$scope.filterTopics = (course) ->
			selected = $scope.courseFilter.topic?.id
			console.log("Filter", $scope.courseFilter.topic, selected)
			return !selected || selected == course.rating
])

.controller('courseDetailCtrl', [
	'$scope', '$routeParams', 'courseFilter', 'Course', 'filterFilter', '$rootScope', 'logger'
	($scope, $routeParams, courseFilter, Course, filterFilter, $rootScope, logger) -> 
		$scope.course = Course.get({id: $routeParams.courseId})
		console.log("Course", $scope.course)		
])