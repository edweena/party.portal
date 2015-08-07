'use strict'

module.exports = ($scope, $rootScope, $state, $timeout, $mdToast, Auth, Graphics) ->

    $scope.tweets = []
    $scope.user = {}
    $scope.users = []

    Graphics.init()



    #see if user is logged in. If not, redirect to login
    if !Auth.isLoggedIn()
        $state.go 'login'


    $scope.flyby =
        on: false


    #Toast Setup
    $scope.toastPosition =
        bottom: true
        top: false
        left: true
        right: false


    $scope.getToastPosition = ->
        return Object.keys $scope.toastPosition
            .filter((pos) ->
                return $scope.toastPosition[pos]
                ).join ' '

    $scope.showToast = (content) ->
        $mdToast.show($mdToast.simple()
            .content(content)
            .position($scope.getToastPosition())
            .hideDelay(3000)
            )



    #WELCOME USER

    $scope.user = Auth.getUser()
    $scope.users.push($scope.user)

    if $scope.user.hasOwnProperty('extraMsg')

        $scope.message = "Welcome #{$scope.user.extraMsg} #{$scope.user.name}"
        $scope.showToast("Welcome #{$scope.user.extraMsg} #{$scope.user.name}")

        $scope.name = $scope.user.name
        $scope.flyby.on = true
        $scope.flyby.text = "Welcome #{$scope.user.extraMsg} To The Party #{$scope.user.name}"

        $timeout(->
            $scope.flyby.on = false
            $scope.flyby.text = ''
            )


