'use strict'

$ = require 'cash-dom'
velocity = require 'velocity-animate'

module.exports = ($timeout, $rootScope, localStorageService, Chat) ->

    return {
        restrict: 'E'
        templateUrl: 'views/partials/chat.html'
        link: (scope, element, attrs) ->
            

            $rootScope.$on 'toggleChat', ->
                element.removeClass 'minimized'

        controllerAs: 'ChatCtrl'

        controller: ($scope) ->

            height = 0
            buffer = 0

            $scope.newChat = {}


            #------------------------
            # Chat Controller
            #------------------------

            $scope.chatControl =
                
                minimized: false
                partyName: ''
                chats: []

                init: ->
                    self = this

                    self.getChats()
                    self.getName()

                minimize: ->
                    self = this
                    self.minimized = true


                maximize: ->
                    self = this
                    self.minimized = false

                #Get user's name
                getName: ->
                    self = this

                    name = localStorageService.get 'partyName'
                    self.partyName = name.toUpperCase()

                getChats: ->
                    self = this
                    self.chats = Chat.query ->

                        $timeout ->
                            self.scrollToBottom()

                toggle: ->
                    self.minimized = !self.minimized
                    console.log self.minimized


                scrollToBottom: ->
                    chat = $('#chat-container')

                    $('#chat-container p').each( ->
                        height += $(this).height()
                        )

                    velocity(chat, {
                        scrollTop: height + buffer
                        })



                #Send message
                sendChat: (text) ->
                    self = this
                    partyName = ''

                    if self.partyName
                        partyName = self.partyName

                    else
                        partyName = 'Guest'

                    obj =
                        text: text
                        name: partyName

                    Chat.save(obj, ->
                        
                        self.chats.push(obj)

                        self.scrollToBottom()

                        $scope.newChat.$setPristine()


                        )


            $scope.chatControl.init()


    }