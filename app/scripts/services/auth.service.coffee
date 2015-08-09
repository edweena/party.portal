'use strict'

Auth = () ->

    loggedIn = false
    instructed = false
    partiedBefore = false
    extraMsg = ''
    user = {}

    return {
        

        isLoggedIn: ->
            return loggedIn
        
        
        
        hasBeenInstructed: (value) ->
            instructed = value


        partiedBefore: (value) ->
            if value
                partiedBefore = value
            else
                partiedBefore = false

            return partiedBefore


        setUser: (userData, xtra) ->

            user = userData
            extraMsg = xtra or ''

        
        setLogin: (value) ->
            loggedIn = value

        
        getUser: ->

            return{
                name: user.name
                extraMsg: extraMsg
            }




    }



module.exports = Auth