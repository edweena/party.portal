'use strict'

module.exports = ($sce) ->
    (url) ->
        return $sce.trustAsResourceUrl(url)