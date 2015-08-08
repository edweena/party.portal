'use strict'

PIXI = require('pixi.js')
raf = require 'raf-loop'


Graphics = ($http, $q) ->


    #CONSTRUCTOR
    FX = ->
        this.width = window.innerWidth
        this.height = window.innerHeight

        this.renderer = new PIXI.WebGLRenderer(window.innerWidth, window.innerHeight)
        this.stage = new PIXI.Container()
        this.stuffContainer = new PIXI.Container()
        this.switchy = false

        #Textures
        this.renderTexture = null
        this.renderTexture2 = null
        this.currentTexture = null
        this.outputSprite = null

        this.filterRGB = new PIXI.filters.ColorMatrixFilter()

        #options
        this.count = 0
        this.items = []
        this.sprites = []
        this.filters = []
        this.itemCount = 5
        this.loop = null

        



        #array of extra images
        this.moreImages = [
            'images/cherry.png',
            'images/dj.png',
            'images/pitbull.png',
            'images/coconut.png'
        ]



        this.init()


    

    #PROTO
    FX.prototype =
        

        initCanvas: ->
            self = this
            self.renderTexture = new PIXI.RenderTexture(self.renderer, self.renderer.width, self.renderer.height)
            self.renderTexture2 = new PIXI.RenderTexture(self.renderer, self.renderer.width, self.renderer.height)
            self.currentTexture = self.renderTexture

            self.outputSprite = new PIXI.Sprite(self.currentTexture)


            #Appends
            parent = document.createElement 'div'
            parent.setAttribute 'id', 'canvas-pixi'

            document.body.appendChild(parent)
            parent.appendChild(self.renderer.view)


            #Align Sprite and add to stage
            self.outputSprite.position.x = self.width / 2
            self.outputSprite.position.y = self.height / 2
            self.outputSprite.anchor.set(0.5)
            self.stage.addChild(self.outputSprite)

            self.stuffContainer.position.x = self.width / 2
            self.stuffContainer.position.y = self.height /2

            self.stage.addChild(self.stuffContainer)

            #Add filter
            self.stage.filters = [self.filterRGB]

            self.initItems()


        

        #PLACE SPRITES
        setItems: (item) ->
            self = this
            
            
            item.position.x = Math.random() * 400 - 200
            item.position.y = Math.random() * 400 - 200
            item.anchor.set(0.5)


            self.stuffContainer.addChild(item)

            #remove previous first item
            # self.stuffContainer.removeChild(self.stuffContainer.children[0])
            self.items.push(item)



        
        #ADD ALL ITEMS
        initItems: ->
            self = this
            index = 0

            #Add a bunch from DB
            while index < self.itemCount
                item = PIXI.Sprite.fromImage(self.sprites[(self.sprites.length - 1) - index])
                console.log 'init', item
                self.setItems(item)
                index++

            #And one random one
            item = PIXI.Sprite.fromImage(self.moreImages[Math.floor(Math.random() * self.moreImages.length)])
            self.setItems(item)

            self.animate()



    


        #self is currently a ref to RAF. NOt good
        animate: ->
            self = this


            for item in self.items
                item.rotation += 0.005

            self.count += 0.01

            

            #swap textures
            temp = self.renderTexture
            self.renderTexture = self.renderTexture2
            self.renderTexture2 = temp

            self.outputSprite.texture = self.renderTexture

            self.stuffContainer.rotation -= 0.01
            self.outputSprite.scale.set(1.01)

            matrix = self.filterRGB.matrix
            matrix[1] = Math.sin(self.count) * 3
            matrix[2] = Math.cos(self.count)
            matrix[3] = Math.cos(self.count) * 1.5
            matrix[4] = Math.sin(self.count / 3) * 2
            matrix[5] = Math.sin(self.count / 2)
            matrix[6] = Math.sin(self.count / 4)

            self.renderTexture2.render(self.stage, null, false)
            self.renderer.render(self.stage)
            
            requestAnimationFrame( ->
                self.animate()
                )


        
        #RESIZE HANDLER
        onResize: ->
            self = this
            width = window.innerWidth
            height = window.innerHeight
            self.renderer.resize(width, height)


        


        #TOGGLE FILTERS
        onClick: ->
            self = this

            self.switchy = !self.switchy

            if !self.switchy
                self.stage.filters = [filter]
            else
                self.stage.filters = null


            #add random image as wel
            self.sprites.push(self.sprites[Math.floor(Math.random() * self.sprites.length)])
            item = PIXI.Sprite.fromImage(self.sprites[self.sprites.length - 1])
            self.setItems(item)


        



        #ADD NEW IMAGE
        addImage: ->
            self = this
            self.sprites.push(image)
            item = PIXI.Sprite.fromImage(self.sprites[self.sprites.length - 1])
            setItems(item)


        




        init: ->
            self = this
            $http.get('https://twit-novel-test.herokuapp.com/api/screengrab')
                .success((response) ->
                    for item in response
                        self.sprites.push(item.imageUrl)


                    self.initCanvas()
                    
                    ).error((err) ->
                        console.log err

                        #use defaults instead of db
                        self.sprites = ['images/lime.png', 'images/coconut.png']
                        self.initItems()
                        self.animate()
                        )

            window.addEventListener('resize', self.onResize, false)


        destroy: ->
            console.log 'Destroy function goes here'




    





    return{
        
        init: ->
            new FX()

    }






module.exports = Graphics

