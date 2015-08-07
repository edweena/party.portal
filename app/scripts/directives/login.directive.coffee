'use strict'

module.exports = ($state, Auth, localStorageService) ->

    return{
        restrict: 'A'
        templateUrl: 'views/partials/loginpage.html'
        link: (scope, element, attrs) ->

            scope.formShowing = false
            scope.beenBefore = false
            scope.user = {}

            if Auth.partiedBefore == true
                scope.beenBefore = true


            #SEE IF USER IS SAVED IN LOCALSTORAGE
            pastName = localStorageService.get('partyName')

            if pastName
                scope.beenBefore = true


                scope.user.name = pastName



    

            #STORE USER IN SERVICE
            scope.setUser = (data, extraMsg) ->

                extraMsg = extraMsg or ''


                Auth.setUser(data, extraMsg)
                Auth.setLogin(true)

                $state.go('main')



            #ADD USER AND ALLOW TO ENTER PARTY
            scope.addUser = (user) ->
                name = user.name

                localStorageService.set('partyName', name)

                scope.setUser(user)

                





            #SHOW FORM BY DEFAULT, OR IF USER WANTS NEW NAME
            scope.showForm = ->
                scope.formShowing = true
    }