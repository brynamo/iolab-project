'use strict'

angular.module('app.models', ['ngResource'])

.factory('Course', [
    '$resource', 'ENV'
    ($resource, ENV) ->
        console.log("API ENDPOINT", ENV.apiEndpoint)
        return $resource(ENV.apiEndpoint+'/courses/:id', {id:'@id'}, { 
        	query: {method:'GET', params:{}, isArray:true}
        	get: {method: 'GET', params:{id:'@id'}, isArray: false},
        })
])

.factory('Domain', [
	'$resource', 'ENV',
  	($resource, ENV) ->
    	return $resource(ENV.apiEndpoint+'/domains/:id/:subresource', {id:'@id'}, { 
    		query: {method:'GET', params:{}, isArray:true}
    		get: {method: 'GET', params:{id:'@id'}, isArray: false},
    		getSubjects: {method:'GET', params:{id:'@id', subresource:"subjects"}, isArray:true}
    	})
])

.factory('Subject', [
	'$resource', 'ENV',
  	($resource, ENV) ->
    	return $resource(ENV.apiEndpoint+'/subjects/:id', {id:'@id'}, { 
    		query: {method:'GET', params:{}, isArray:true}
    		get: {method: 'GET', params:{id:'@id'}, isArray: false},
    	})
])

.factory('SkillLevel', [
	'$resource', 'ENV',
  	($resource, ENV) ->
    	return $resource(ENV.apiEndpoint+'/skill_levels/:id', {id:'@id'}, { 
    		query: {method:'GET', params:{}, isArray:true}
    		get: {method: 'GET', params:{id:'@id'}, isArray: false},
    	})
])