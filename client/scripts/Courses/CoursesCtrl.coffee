'use strict'
angular.module('app.courses.catalog', [])

.controller('courseBrowseCtrl', [
	'$scope', 'courseFilter', 'courseUI', 'Course', 'Subject', 'filterFilter', '$rootScope', 'logger'
	($scope, courseFilter, courseUI, Course, Subject, filterFilter, $rootScope, logger) -> 
		#$scope.courses = Course.query()
		
		$scope.courseFilter = courseFilter.getFilter()
		$scope.filterOptions = courseFilter.getOptions()
		$scope.$watch('courseFilter.domain', (newValue, oldValue) -> 
			if newValue != oldValue
				courseFilter.refreshSubjects(newValue)
		)

		$scope.$watchCollection('[courseFilter.domain, courseFilter.subject, courseFilter.level]', (newValues, oldValues) ->
			console.log("Seen", newValues, oldValues)
			$scope.courses = Course.query({subject: $scope.courseFilter.subject?.id, skill_level: $scope.courseFilter.level?.id})
		)

		$scope.domainColor = courseUI.domainColor
		$scope.subjectName = courseUI.subjectName
		$scope.getRatingStars = courseUI.getRatingStars

		###subjects = Subject.query()
		getSubject = (subjectId) ->
			if subjects.length > 0
				return _.findWhere(subjects, {id:subjectId})
			return {}

		getDomain = (subjectId) ->
			subject = getSubject(subjectId)
			if subject.domain_id and courseFilter.getOptions().domains.length > 0
				return _.findWhere(courseFilter.getOptions().domains, {id: subject.domain_id})
			return null

		$scope.domainColor = (subjectId) -> 
			domain = getDomain(subjectId)
			return if domain then domain.color else "primary"

		$scope.subjectName = (subjectId) ->
			subject = getSubject(subjectId)
			return subject.name or ""

		$scope.getRatingStars = (rating) ->
			return (Array(rating + 1).join "\u2605") + (Array(5 + 1-rating).join "\u2606")###

		$scope.filterTopics = (course) ->
			selectedDomain = $scope.courseFilter.domain?.id
			selectedSubject = $scope.courseFilter.subject?.id
			selectedLevel = $scope.courseFilter.level
			courseDomain = getDomain(course.subject_id)
			#console.log("filter", selectedDomain, courseDomain, course.name) if selectedDomain
			return (!selectedDomain or !courseDomain or selectedDomain == courseDomain.id) and 
				(!selectedSubject or selectedSubject == course.subject_id) 
])