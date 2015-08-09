'use strict'


module.exports = ->

    return{
        restrict: 'A'
        replace: true
        
        scope:
            playlist: '@playlist'
        
        template: '<iframe id="soundcloud" ' +
            'src="{{playlist | trusted}}" ' +
            'width="100%" height="20" frameborder="no" scrolling="no">' +
            '</iframe>'
    }
