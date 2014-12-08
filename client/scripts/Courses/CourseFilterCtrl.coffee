'use strict'
angular.module('app.courses.filter', [])

.controller('courseFilterCtrl', [
	'$scope', '$location', 'courseFilter', 'Domain', 'filterFilter', '$rootScope', 'logger'
	($scope, $location, courseFilter, Domain, filterFilter, $rootScope, logger) -> 
		
		calcCurrentStep = () ->
			if $scope.courseFilter.subject
				return 3
			if $scope.courseFilter.domain
				return 2
			return 1

		$scope.showCatalog = () ->
			courseFilter.setFilter($scope.courseFilter)
			$location.path("/courses")

		$scope.courseFilter = courseFilter.getFilter()
		$scope.currentStep = calcCurrentStep()

		$scope.filterOptions = courseFilter.getOptions()

		$scope.$watchCollection('[courseFilter.domain, courseFilter.subject, courseFilter.level]', (newValues, oldValues) ->
			$scope.currentStep = Math.max($scope.currentStep, calcCurrentStep())
		)

		$scope.$watch('courseFilter.domain', (newValue, oldValue) -> 
			if newValue != oldValue
				courseFilter.refreshSubjects(newValue)
		)

		$scope.$watch('courseFilter.level', (newValue, oldValue) -> 
			if newValue != oldValue
				$scope.showCatalog()
		)



])
