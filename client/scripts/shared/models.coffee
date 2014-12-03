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
