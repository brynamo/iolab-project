'use strict';

angular.module('app.courses', [])

angular.module('app', [
    # Angular modules
    'ngRoute'
    'ngAnimate'

    # 3rd Party Modules
    'ui.bootstrap'

    # Custom modules
    'app.controllers'
    'app.directives'
    'app.localization'
    'app.models'
    'app.courses'
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