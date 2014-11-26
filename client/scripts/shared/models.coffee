'use strict'

apiRoot = "http://localhost:3333" # For testing

angular.module('app.models', ['ngResource'])

.factory('Course', [
	'$resource',
  	($resource) ->
    	return $resource(apiRoot+'/courses', {}, { 
    		query: {method:'GET', params:{}, isArray:true}
    	})
])
