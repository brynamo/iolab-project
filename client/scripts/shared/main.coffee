'use strict';

angular.module('app.controllers', [])

# overall control
.controller('AppCtrl', [
    '$scope', '$location'
    ($scope, $location) ->
        $scope.isSpecificPage = ->
            path = $location.path()
            return _.contains( ['/404', '/pages/500'], path )

        $scope.main =
            brand: 'SomeName'
            name: 'Jeppe Stougaard' # those which uses i18n can not be replaced with two way binding var for now.
        $scope.course_filter = 
            domain: -1
            topic: -1
            skill: -1

])

.controller('NavCtrl', [
    '$scope', 'taskStorage', 'filterFilter'
    ($scope, taskStorage, filterFilter) ->
        # init
        tasks = $scope.tasks = taskStorage.get()
        $scope.taskRemainingCount = filterFilter(tasks, {completed: false}).length

        $scope.$on('taskRemaining:changed', (event, count) ->
            $scope.taskRemainingCount = count
        )
])

.factory('logger', [ ->

    # toastr setting.
    toastr.options =
        "closeButton": true
        "positionClass": "toast-bottom-right"
        "timeOut": "3000"

    logIt = (message, type) ->
        toastr[type](message)

    return {
        log: (message) ->
            logIt(message, 'info')
            # return is needed, otherwise AngularJS will error out 'Referencing a DOM node in Expression', thanks https://groups.google.com/forum/#!topic/angular/bsTbZ86WAY4
            return 

        logWarning: (message) ->
            logIt(message, 'warning')
            return

        logSuccess: (message) ->
            logIt(message, 'success')
            return

        logError: (message) ->
            logIt(message, 'error')
            return
    }
])
