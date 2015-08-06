'use strict'

onConfig = ($urlRouterProvider, $stateProvider) ->

    $urlRouterProvider.otherwise('/login')

    $stateProvider
        
        .state 'main',
            url: '/'
            controller: 'MainCtrl'
            templateUrl: 'views/main.html'
            title: 'Main'

        .state 'login',
            url: '/login'
            templateUrl: 'views/login.html'

    


module.exports = onConfig