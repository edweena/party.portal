'use strict'


Twitter = ($http, $q) ->

    return {
        

        tweets:
            tweetArray: []
            cleanedTweets: []
            userArray: []
            baseUrl: 'http://twit-novel-test.herokuapp.com/api'

            #process individual tweet
            processData: (tweet) ->

                #get rid of @rds_zone
                tweet.text = tweet.text.substring(10)

                return tweet


            getUsers: ->
                self = this
                deferred = $q.defer()

                $http.get(self.baseUrl + '/users')
                    .success((data) ->

                        self.userArray = data
                        deferred.resolve(self.userArray)
                        ).error((data, status, headers) ->
                            console.log data, status, headers
                            deferred.reject(status)
                            )

                return deferred.promise

            getData: ->
                self = this
                deferred = $q.defer()


                cleanData = ->
                    self.cleanedTweets = []

                    tweets = self.tweetArray

                    for tweet, index in tweets
                        tweet = tweets[index]


                    #cut out @rds_zone
                    tweet.text = tweet.text.substring(10)

                    #push to cleaned tweets
                    self.cleanedTweets.push(tweet)

                    deferred.resolve(self.cleanedTweets)

                
                $http.get(self.baseUrl + '/tweets')
                    .success((data) ->
                        self.tweetArray = data
                        cleanData(self.tweetArray)
                        ).error((data, status, headers) ->
                            console.log data, status, headers
                            deferred.reject(status)
                            )

                

                return deferred.promise

    }


module.exports = Twitter









