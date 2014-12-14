'use strict'
angular.module('app.courses.services', [])

.service('courseFilter', [
	'Domain', 'Subject', 'SkillLevel', '$location'
	(Domain, Subject, SkillLevel, $location) ->

		filter = {}

		params = _.pick($location.search(), "domain_id", "subject_id", "level_id")
		callbackCount = 0
		callbackGenerator = (filterKey, paramValue) ->
			return (values) ->
				if paramValue
					filter[filterKey] = _.findWhere(values,{id: paramValue})
					callbackCount++


		filterOptions = 
			domains: Domain.query(callbackGenerator("domain", params.domain_id))
			subjects: Subject.query(callbackGenerator("subject", params.subject_id))
			levels: SkillLevel.query(callbackGenerator("level", params.level_id))

		return {
			setFilter: (filter) ->
				filter =
					domain: filter.domain
					subject: filter.subject
					level: filter.level
			refreshSubjects: (domain) ->
				#console.log("refreshSubjects", domain)
				filterOptions.subjects = if domain then Domain.getSubjects({id:domain.id}) else Subject.query()
			getFilter: () ->
				return filter
			getFilterSearch: () ->
				return {
					domain_id: filter.domain?.id
					subject_id: filter.subject?.id
					level_id:filter.level?.id
				}
			getOptions: () ->
				return filterOptions
			isReady: () ->
				return _.isEmpty(params) or callbackCount >= _.size(params);

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
				if subject and subject.domain_id and domains.length > 0
					return _.findWhere(domains, {id: subject.domain_id})
				return null

		cachedDomainColors = {}

		return {
			getSubject: getSubject

			getDomain: getDomain

			domainColor: (subjectId) -> 
				if subjectId not of cachedDomainColors
					domain = getDomain(subjectId)
					#console.log("Domain color", domain);
					cachedDomainColors[subjectId] = if domain && domain.color_code then domain.color_code else "primary"
				return cachedDomainColors[subjectId]

			subjectName: (subjectId) ->
				subject = getSubject(subjectId)
				return if subject then subject.subject else ""

			getRatingStars: (rating) ->
				rating = if rating then Math.round(rating) else 0
				return if rating? and rating > 0 then (Array(rating + 1).join "\u2605") + (Array(5 + 1-rating).join "\u2606") else ""
		}
])