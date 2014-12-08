'use strict'
angular.module('app.courses.services', [])

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

.service('courseUI', [
	'Domain', 'Subject', 'SkillLevel'
	(Domain, Subject, SkillLevel) ->

		domains = Domain.query()
		subjects = Subject.query()

		getSubject = (subjectId) ->
				if subjects.length > 0
					return _.findWhere(subjects, {id:subjectId})
				return {}
		getDomain = (subjectId) ->
				subject = getSubject(subjectId)
				if subject.domain_id and domains.length > 0
					return _.findWhere(domains, {id: subject.domain_id})
				return null

		return {
			getSubject: getSubject

			getDomain: getDomain

			domainColor: (subjectId) -> 
				domain = getDomain(subjectId)
				return if domain then domain.color else "primary"

			subjectName: (subjectId) ->
				subject = getSubject(subjectId)
				return subject.name or ""

			getRatingStars: (rating) ->
				return if rating? and rating > 0 then (Array(rating + 1).join "\u2605") + (Array(5 + 1-rating).join "\u2606") else ""
		}
])