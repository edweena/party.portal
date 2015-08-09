'use strict'

Draggable = require 'draggable'

module.exports = ($rootScope, UploadImage, Graphics) ->
    return{
        
        restrict: 'A'
        templateUrl: 'views/partials/cameracapture.html'

        link: (scope) ->
            
            width = 200
            height = 0
            streaming = false

            video = null
            canvas = null
            photo = null
            cameraStream = null

            startbutton = null


            #Set as draggable
            cambox = document.getElementById 'camera'

            new Draggable(cambox)


            #---------------------------------------
            # Utility Functions
            #


            clearPhoto = ->
                context = canvas.getContext('2d')
                context.fillStyle = '#AAA'
                context.fillRect 0, 0, canvas.width, canvas.height
                data = canvas.toDataURL('image/jpeg')
                return


            


            dataURItoBlob = (dataURI) ->
                binary = atob(dataURI.split(',')[1])
                array = []

                i = 0

                while i < binary.length
                    array.push binary.charCodeAt(i)
                    i++

                new Blob([ new Uint8Array(array) ], type: 'image/jpeg')



            takePicture = ->
                context = canvas.getContext '2d'

                if width and height
                    canvas.width = width
                    canvas.height = height
                    context.drawImage(video, 0, 0, width, height)


                    #Get data URI
                    data = canvas.toDataURL 'image/jpeg'



                    #Get S3 policy
                    UploadImage.getPolicy('image/jpeg').then((response) ->

                        console.log response

                        awsParams = response

                        #Send base64 encode to server
                        img = dataURItoBlob(data)

                        #give file completely random name
                        name = scope.name +
                            Math.floor(Math.random() * 10000) + '.jpg'


                        UploadImage.upload(img, name, awsParams)
                            .then((response) ->

                                imageUrl = response.PostResponse.Location
                                imageKey = response.PostResponse.Key

                                imageObject =
                                    imageUrl: imageUrl
                                    imageKey: imageKey


                                #Save to DB
                                UploadImage.save(imageObject).then ((response) ->

                                    #send to graphics service
                                    Graphics.addImage imageUrl
                                    $rootScope.$broadcast 'msg', 'Image uploaded!'
                                    return
                                ), (err) ->
                                    console.log err
                                    $rootScope.$broadcast 'msg', 'Sorry, photo failed to save'
                                    return
                                )
                        )
                    return
                else
                    clearPhoto()



            

            #---------------------------------------
            # scope methods
            #




            scope.camera =
                open: false
                takePicture: ->
                    console.log 'take picture!'
                    this.open = true



            scope.closeCamera = ->


                #shut down video
                video.pause()
                video.src = null or ''
                cameraStream.stop()
                cameraStream = null
                scope.camera.open = false

            


            scope.startup = ->
                video = document.getElementById('video')
                canvas = document.getElementById('camera-canvas')

                startbutton = document.getElementById('startbutton')

                navigator.getMedia = navigator.getUserMedia or
                    navigator.webkitGetUserMedia or
                    navigator.mozGetUserMedia or
                    navigator.msGetUserMedia
                

                navigator.getMedia {
                    video: true
                    audio: false
                }, ((stream) ->

                    if navigator.mozGetUserMedia
                        video.mozSrcObject = stream
                    else
                        vendorURL = window.URL or window.webkitURL
                        video.src = vendorURL.createObjectURL(stream)

                    cameraStream = stream
                    
                    video.play()
                    return
                ), (err) ->
                    console.log 'Error with vid', err
                    return

                video.addEventListener 'canplay', ((ev) ->

                    if !streaming
                        height = video.videoHeight / (video.videoWidth / width)

                        if isNaN(height)
                            height = width / (4 / 3)

                        video.setAttribute 'width', width
                        video.setAttribute 'height', height
                        canvas.setAttribute 'width', width
                        canvas.setAttribute 'height', height

                        streaming = true
                        return
                ), false

                clearPhoto()
                return


            scope.startPhoto = (ev) ->
                takePicture()
                ev.preventDefault()




            scope.startup()




  }
