'use strict'

PIXI = require 'pixi.js'
raf = require 'raf-loop'


Graphics = (PhotoFetch) ->


    alreadyInit = false
    graphicMethods = null

    


    #CONSTRUCTOR
    FX = ->

        self = this

        this.width = window.innerWidth
        this.height = window.innerHeight

        this.renderer = new PIXI.WebGLRenderer(
            window.innerWidth, window.innerHeight
            )

        this.stage = new PIXI.Container()
        this.stuffContainer = new PIXI.Container()
        this.switchy = false

        #Textures
        this.renderTexture = null
        this.renderTexture2 = null
        this.currentTexture = null
        this.outputSprite = null

        this.filterRGB = new PIXI.filters.ColorMatrixFilter()
        this.filterRGB2 = new PIXI.filters.ColorMatrixFilter()

        #options
        this.count = 0
        this.items = []
        this.sprites = []
        this.filters = []
        this.itemCount = 5
        this.loop = null


        this.addImage = (img) ->
            self.onAddImage(img)

        this.flip = ->
            self.onClick()




        #array of extra images
        this.moreImages = [
            'images/cherry.png',
            'images/dj.png',
            'images/pitbull.png',
            'images/coconut.png'
        ]

        this.init()



        # this.init()


    

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
            self.stage.filters = [self.filterRGB, self.filterRGB2]

            self.initItems()
            alreadyInit = true


        

        #PLACE SPRITES
        setItems: (item) ->
            self = this
            
            
            item.position.x = Math.random() * 400 - 200
            item.position.y = Math.random() * 400 - 200
            item.anchor.set(0.5)


            self.stuffContainer.addChild(item)

            self.items.push(item)



        
        #ADD ALL ITEMS
        initItems: ->
            self = this
            index = 0

            #Add a bunch from DB
            while index < self.itemCount

                item = PIXI.Sprite.fromImage(
                    self.sprites[(self.sprites.length - 1) - index]
                    )

                self.setItems(item)
                index++

            #And one random one
            item = PIXI.Sprite.fromImage(
                self.moreImages[Math.floor(Math.random() * self.moreImages.length)]
                )
            self.setItems(item)


            #once they are all in, remove first child
            #remove previous first item
            self.stuffContainer.removeChild(self.stuffContainer.children[0])

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

            matrix2 = self.filterRGB2.matrix
            matrix2[1] = Math.sin(self.count) * 1.5
            matrix2[2] = Math.cos(self.count) / 3
            matrix2[3] = Math.cos(self.count) / 1.5
            matrix2[4] = Math.sin(self.count * 3) * 2
            matrix2[5] = Math.sin(self.count / 6)
            matrix2[6] = Math.sin(self.count / 2)

            self.renderTexture2.render(self.stage, null, false)
            self.renderer.render(self.stage)
            
            requestAnimationFrame( ->
                self.animate()
                )


        
        #RESIZE HANDLER
        onResize: (self) ->
            width = window.innerWidth
            height = window.innerHeight
            self.renderer.resize(width, height)


        


        #TOGGLE FILTERS
        onClick: ->
            self = this

            self.switchy = !self.switchy



            if !self.switchy
                self.stage.filters = [self.filterRGB]
            else
                self.stage.filters = [self.filterRGB2]


            #add random image as well
            self.sprites.push(
                self.sprites[Math.floor(Math.random() * self.sprites.length)]
                )

            item = PIXI.Sprite.fromImage(self.sprites[self.sprites.length - 1])
            self.setItems(item)


        



        #ADD NEW IMAGE
        onAddImage: (image) ->
            self = this
            self.sprites.push(image)
            item = PIXI.Sprite.fromImage(self.sprites[self.sprites.length - 1])
            self.setItems(item)


        



        #add in error callback
        init: ->
            self = this

            PhotoFetch.get().then((response) ->

                for item in response
                    self.sprites.push(item.imageUrl)

                self.initCanvas()
            )

            window.addEventListener 'resize', ->
                self.onResize(self)
            ,false



        


        destroy: ->
            console.log 'Destroy function goes here'


    




    





    return{
        
        init: ->
            graphicMethods = new FX()

        alreadyInit: ->
            return alreadyInit

        addImage: (image) ->
            graphicMethods.addImage(image[0])

        flip: ->
            graphicMethods.flip()

    }






module.exports = Graphics

