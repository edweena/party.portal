'use strict'

module.exports = ($scope, $state, Auth) ->


    $scope.logInPage = false

    $scope.$watch 'instructed', (value) ->
        if value
            $scope.logInPage = true

