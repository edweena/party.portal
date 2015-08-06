'use strict'

module.exports = ($scope, $rootScope) ->

    $scope.tweets = []


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

    
