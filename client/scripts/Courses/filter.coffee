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