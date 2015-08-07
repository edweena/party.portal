'use strict'

onConfig = ($urlRouterProvider, $stateProvider) ->

    $urlRouterProvider.otherwise('/')

    $stateProvider
        
        .state 'main',
            url: '/'
            controller: 'MainCtrl'
            templateUrl: 'views/main.html'
            title: 'Main'

        .state 'login',
            url: '/login'
            controller: 'LoginCtrl'
            templateUrl: 'views/login.html'

    


module.exports = onConfig