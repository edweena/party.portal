'use strict'


module.exports = ->
    return{
        
        restrict: 'E'
        templateUrl: 'views/partials/settings.html'
        link: (scope) ->

            scope.settings =
                open: false
                playlist: 'https://w.soundcloud.com/player/' +
                    '?url=https%3A//api.soundcloud.com/tracks/' +
                    '207678255%3Fsecret_token%3Ds-Z3c7B&amp;' +
                    'color=f6cd23&amp;inverse=true&amp;' +
                    'auto_play=true&amp;show_user=true'

                playlists: [
                    'Salsa',
                    'Cumbia',
                    'Metal',
                    'Italo']

                currentPlaylist: ''

                toggleOpen: ->
                    self = this
                    self.open = !self.open


                changeMusic: (list) ->

                    self = this
                    self.playlist = ''

                    if list == 'cumbia'
                        self.playlist = 'https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/207678255&amp;color=f6cd23&amp;inverse=true&amp;auto_play=true&amp;show_user=true'
                    else
                        self.playlist = 'https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/133273346&amp;color=f6cd23&amp;inverse=true&amp;auto_play=true&amp;show_user=true'






            scope.$watch 'settings.currentPlaylist', (val) ->
                if val.length > 0
                    scope.settings.changeMusic(val)
                else
                    return








    }