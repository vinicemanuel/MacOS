//
//  GameScene.swift
//  Project_11
//
//  Created by vinicius emanuel on 03/06/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bubbleTextures = [SKTexture]()
    var bubbles = [SKSpriteNode]()
    var currentBubbleTexture = 0
    var maximumNumber = 1
    
    override func didMove(to view: SKView) {
        self.bubbleTextures.append(SKTexture(imageNamed: "bubbleBlue"))
        self.bubbleTextures.append(SKTexture(imageNamed: "bubbleCyan"))
        self.bubbleTextures.append(SKTexture(imageNamed: "bubbleGray"))
        self.bubbleTextures.append(SKTexture(imageNamed: "bubbleGreen"))
        self.bubbleTextures.append(SKTexture(imageNamed: "bubbleOrange"))
        self.bubbleTextures.append(SKTexture(imageNamed: "bubblePink"))
        self.bubbleTextures.append(SKTexture(imageNamed: "bubblePurple"))
        self.bubbleTextures.append(SKTexture(imageNamed: "bubbleRed"))
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = CGVector.zero
        
        for _ in 1 ... 8 {
            createBubble()
        }
    }
    
    func createBubble() {
        let bubble = SKSpriteNode(texture: bubbleTextures[currentBubbleTexture])
        bubble.name = String(maximumNumber)
        bubble.zPosition = 1

        let label = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        label.verticalAlignmentMode = .center
        label.text = bubble.name
        label.color = NSColor.white
        label.fontSize = 64
        label.zPosition = 2
        bubble.addChild(label)

        bubbles.append(bubble)
        addChild(bubble)

        let xPos = Int.random(in: 0..<800)
        let yPos = Int.random(in: 0..<600)
        bubble.position = CGPoint(x: xPos, y: yPos)

//        let scale = CGFloat.random(in: 0...1)
//        bubble.setScale(max(0.7, scale))
//
//        bubble.alpha = 0
//        bubble.run(SKAction.fadeIn(withDuration: 0.5))

        configurePhysics(for: bubble)
        nextBubble()
    }
    
    func configurePhysics(for bubble: SKSpriteNode) {
        bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.width / 2)
        bubble.physicsBody?.linearDamping = 0.0
        bubble.physicsBody?.angularDamping = 0.0
        bubble.physicsBody?.restitution = 1.0
        bubble.physicsBody?.friction = 0.0

        let motionX = CGFloat.random(in: -200...200)
        let motionY = CGFloat.random(in: -200...200)

        bubble.physicsBody?.velocity = CGVector(dx: motionX, dy: motionY)
        bubble.physicsBody?.angularVelocity = CGFloat.random(in: 0...1)
    }
    
    func nextBubble() {
        currentBubbleTexture += 1

        if currentBubbleTexture == bubbleTextures.count {
            currentBubbleTexture = 0
        }

        maximumNumber += Int.random(in: 1...3)
        let strMaximumNumber = String(maximumNumber)

        if strMaximumNumber.last! == "6" {
            maximumNumber += 1
        }

        if strMaximumNumber.last! == "9" {
            maximumNumber += 1
        }
    }
}
