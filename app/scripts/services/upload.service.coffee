'use strict'


# parser = require 'xml2json'

parseString = require('xml2js').parseString


UploadImage = ($http, $q, $rootScope, Upload) ->

    s3 =
        url: 'https://s3.amazonaws.com/rds-party-assets'
        sigUrl: 'https://twit-novel-test.herokuapp.com/api/upload/policy'
        removeUrl: 'https://twit-novel-test.herokuapp.com/api/upload/remove'
        imgFolder: 'images/'
        saveUrl: 'https://twit-novel-test.herokuapp.com/api/screengrab'




    return{



        #Generate upload policy
        getPolicy: (fileType) ->
            self = this
            deferred = $q.defer()

            #getSig
            $http.get(s3.sigUrl + '?mimeType=' + fileType)
                .success ((response) ->
                    console.log response
                    s3Params = response
                    deferred.resolve(s3Params)
                )
                .error((err) ->
                    console.log err
                    deferred.reject(err)
                )

            return deferred.promise


        upload: (file, name, awsParams) ->
            self = this
            deferred = $q.defer()

            Upload.upload
                url: s3.url
                method: 'POST'
                transformRequest: (data, headersGetter) ->
                    headers = headersGetter()
                    delete headers['Authorization']
                    return data

                fields:
                    key: 'images/' + name
                    AWSAccessKeyId: awsParams.AWSAccessKeyId
                    acl: 'public-read'
                    policy: awsParams.s3Policy
                    signature: awsParams.s3Signature
                    'Content-Type': file.type
                    'success_action_status': 201

                file: file

            .progress((evt) ->
                progressPercentage = parseInt(
                    100.0 * evt.loaded / evt.total, 10
                    )
                $rootScope.$broadcast 'progressPercent', progressPercentage
                )

            .success((response) ->
                #convert XML response to JSON
                parseString(response, (err, result) ->

                    console.log result

                    jsonResponse = result
                    deferred.resolve(jsonResponse)
                    )

                

                )

            .error((error) ->

                parseString(error, (err, result) ->
                    console.log result
                    jsonResponse = result
                    deferred.resolve(jsonResponse)
                    )
                )

            return deferred.promise



        #REMOVE
        removeImage: (imageKey) ->
            self = this
            deferred = $q.defer()

            image =
                key: imageKey


            $http.post(s3.removeUrl, image)
                .success((response) ->
                    deferred.resolve response
                    )
                .error((err) ->
                    deferred.reject err
                    )

            return deferred.promise


        #SAVE
        save: (imageObject) ->
            self = this

            deferred = $q.defer()

            $http.post(s3.saveUrl, imageObject)
                .success((response) ->
                    deferred.resolve response
                    )
                .error((err) ->
                    deferred.reject err
                    )

            return deferred.promise



    }



module.exports = UploadImage