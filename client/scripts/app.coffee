'use strict';

angular.module('app', [
    # Angular modules
    'ngRoute'
    'ngAnimate'
    'ngTagsInput'

    # 3rd Party Modules
    'ui.bootstrap'

    # Custom modules
    'app.config'
    'app.controllers'
    'app.directives'
    'app.localization'
    'app.models'
    'app.courses.services'
    'app.courses.filter'
    'app.courses.catalog'
    'app.courses.details'
])
    
.config([
    '$routeProvider'
    ($routeProvider) ->
        $routeProvider
            .when(
                '/'                                         # dashboard
                #redirectTo: '/courses'
                templateUrl: 'views/courses/filter.html'
                controller: 'courseFilterCtrl' # TODO: Change
            )
            .when(
                '/courses'
                templateUrl: 'views/courses/courses.html'
                controller: 'courseBrowseCtrl'
                reloadOnSearch: false
            )
            .when(
                '/courses/:courseId'
                templateUrl: 'views/courses/course_detail.html'
                controller: 'courseDetailCtrl'
            )

            .otherwise(
                redirectTo: '/404'
            )
])