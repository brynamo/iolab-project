'use strict'

angular.module('app.models', ['ngResource'])

.factory('Course', [
	'$resource',
  	($resource) ->
    	return $resource('courses.json', {}, { 
    		query: {method:'GET', params:{}, isArray:true}
    	})
])
