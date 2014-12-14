'use strict'
angular.module('app.courses.catalog', [])

.controller('courseBrowseCtrl', [
	'$scope', 'courseFilter', 'courseUI', 'Course', 'Subject', '$location', '$rootScope', 'logger'
	($scope, courseFilter, courseUI, Course, Subject, $location, $rootScope, logger) -> 
		#$scope.courses = Course.query()
		
		$scope.courseFilter = courseFilter.getFilter()
		$scope.filterOptions = courseFilter.getOptions()

		$scope.$watchCollection('[courseFilter.domain, courseFilter.subject, courseFilter.level]', (newValues, oldValues) ->
			#console.log("Saw change", courseFilter.isReady())
			if courseFilter.isReady()
				$scope.courses = Course.query({subject: $scope.courseFilter.subject?.id, rigor: $scope.courseFilter.level?.id})
				$location.search(courseFilter.getFilterSearch());
		)

		$scope.$watch('courseFilter.domain', (newValue, oldValue) -> 
			if courseFilter.isReady() and newValue != oldValue
				courseFilter.refreshSubjects(newValue)
		)

		$scope.domainColor = courseUI.domainColor
		$scope.subjectName = courseUI.subjectName
		$scope.getRatingStars = courseUI.getRatingStars

		$scope.filterTopics = (course) ->
			selectedDomain = $scope.courseFilter.domain?.id
			selectedSubject = $scope.courseFilter.subject?.id
			selectedLevel = $scope.courseFilter.level
			courseDomain = getDomain(course.subject_id)
			#console.log("filter", selectedDomain, courseDomain, course.name) if selectedDomain
			return (!selectedDomain or !courseDomain or selectedDomain == courseDomain.id) and 
				(!selectedSubject or selectedSubject == course.subject_id) 
])