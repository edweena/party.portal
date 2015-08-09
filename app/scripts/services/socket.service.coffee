'use strict'

Socket = (socketFactory) ->

    return{
        ioSocket: io.connect 'http://twit-novel-test.herokuapp.com'
    }



module.exports = Socket