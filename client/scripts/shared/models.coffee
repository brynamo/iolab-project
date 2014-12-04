'use strict'

apiRoot = "http://localhost:3333" # For testing

angular.module('app.models', ['ngResource'])

.factory('Course', [
	'$resource',
  	($resource) ->
    	return $resource(apiRoot+'/courses/:id', {id:'@id'}, { 
    		query: {method:'GET', params:{}, isArray:true}
    		get: {method: 'GET', params:{id:'@id'}, isArray: false},
    	})
])

.factory('Domain', [
	'$resource',
  	($resource) ->
    	return $resource(apiRoot+'/domains/:id/:subresource', {id:'@id'}, { 
    		query: {method:'GET', params:{}, isArray:true}
    		get: {method: 'GET', params:{id:'@id'}, isArray: false},
    		getSubjects: {method:'GET', params:{id:'@id', subresource:"subjects"}, isArray:true}
    	})
])

.factory('Subject', [
	'$resource',
  	($resource) ->
    	return $resource(apiRoot+'/subjects/:id', {id:'@id'}, { 
    		query: {method:'GET', params:{}, isArray:true}
    		get: {method: 'GET', params:{id:'@id'}, isArray: false},
    	})
])

.factory('SkillLevel', [
	'$resource',
  	($resource) ->
    	return $resource(apiRoot+'/skill_levels/:id', {id:'@id'}, { 
    		query: {method:'GET', params:{}, isArray:true}
    		get: {method: 'GET', params:{id:'@id'}, isArray: false},
    	})
])