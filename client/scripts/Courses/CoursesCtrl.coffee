'use strict'
angular.module('app.courses', [])

.service('courseFilter', [
	'Domain', 'Subject', 'SkillLevel'
	(Domain, Subject, SkillLevel) ->

		filterOptions = 
			domains: Domain.query()
			subjects: Subject.query()
			levels: SkillLevel.query()

		filter = {}
		return {
			setFilter: (filter) ->
				filter =
					domain: filter.domain
					subject: filter.domain
					level: filter.domain
			refreshSubjects: (domain) ->
				console.log("refreshSubjects", domain)
				filterOptions.subjects = if domain then Domain.getSubjects({id:domain.id}) else Subject.query()
			getFilter: () ->
				return filter
			getOptions: () ->
				return filterOptions
		}
])

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


.controller('courseBrowseCtrl', [
	'$scope', 'courseFilter', 'Course', 'Subject', 'filterFilter', '$rootScope', 'logger'
	($scope, courseFilter, Course, Subject, filterFilter, $rootScope, logger) -> 
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

		subjects = Subject.query()
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
			return (Array(rating + 1).join "\u2605") + (Array(5 + 1-rating).join "\u2606")

		$scope.filterTopics = (course) ->
			selectedDomain = $scope.courseFilter.domain?.id
			selectedSubject = $scope.courseFilter.subject?.id
			selectedLevel = $scope.courseFilter.level
			courseDomain = getDomain(course.subject_id)
			#console.log("filter", selectedDomain, courseDomain, course.name) if selectedDomain
			return (!selectedDomain or !courseDomain or selectedDomain == courseDomain.id) and 
				(!selectedSubject or selectedSubject == course.subject_id) 
])

.controller('courseDetailCtrl', [
	'$scope', '$routeParams', 'courseFilter', 'Course', 'filterFilter', '$rootScope', 'logger'
	($scope, $routeParams, courseFilter, Course, filterFilter, $rootScope, logger) -> 
		$scope.course = Course.get({id: $routeParams.courseId})
		console.log("Course", $scope.course)		
])