'use strict'


module.exports = () ->

    return {
        

        restrict: 'A'
        

        link: (scope, element, attrs) ->

            message = attrs.message

            encodedMessage = encodeURIComponent(message)


            baseUrl = 'http://tts-api.com/tts.mp3?q='


            audio = document.getElementById 'audioplayer'
            target = document.getElementById 'audiosrc'

            

            loadAndPlay = (msg) ->

                message = msg.toLowerCase()
                encodedMessage = encodeURIComponent(message)

                target.src = ''
                target.src = baseUrl + encodedMessage
                audio.load()
                audio.play()


            loadAndPlay(message)


            scope.$on 'newTweet', (event, msg) ->
                loadAndPlay(msg)

    }
