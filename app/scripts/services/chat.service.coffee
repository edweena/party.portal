'use strict'


Chat = ($resource) ->

    baseUrl = 'http://twit-novel-test.herokuapp.com/api/chats'

    return $resource(baseUrl)



module.exports = Chat