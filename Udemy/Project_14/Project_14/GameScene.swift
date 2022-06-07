//
//  GameScene.swift
//  Project_14
//
//  Created by vinicius emanuel on 07/06/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bulletsSprite: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var targetSpeed = 4.0
    var targetDelay = 0.8
    var targetsCreated = 0
    
    override func didMove(to view: SKView) {
        self.createBackground()
        self.createWater()
        self.createOverlay()
        self.levelUp()
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 400, y: 300)
        background.blendMode = .replace
        addChild(background)

        let grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.position = CGPoint(x: 400, y: 300)
        addChild(grass)
        grass.zPosition = 100
    }
    
    func createWater() {
        func animate(_ node: SKNode, distance: CGFloat, duration: TimeInterval) {
            let movementUp = SKAction.moveBy(x: 0, y: distance, duration: duration)
            let movementDown = movementUp.reversed()
            let sequence = SKAction.sequence([movementUp, movementDown])
            let repeatForever = SKAction.repeatForever(sequence)
            node.run(repeatForever)
        }
        
        let waterBackground = SKSpriteNode(imageNamed: "water-bg")
        waterBackground.position = CGPoint(x: 400, y: 180)
        waterBackground.zPosition = 200
        addChild(waterBackground)


        let waterForeground = SKSpriteNode(imageNamed: "water-fg")
        waterForeground.position = CGPoint(x: 400, y: 120)
        waterForeground.zPosition = 300
        addChild(waterForeground)
        
        animate(waterBackground, distance: 8, duration: 1.3)
        animate(waterForeground, distance: 12, duration: 1)
    }
    
    func createOverlay() {
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 400, y: 300)
        curtains.zPosition = 400
        addChild(curtains)
        
        bulletsSprite = SKSpriteNode(imageNamed: "shots3")
        bulletsSprite.position = CGPoint(x: 170, y: 60)
        bulletsSprite.zPosition = 500
        addChild(bulletsSprite)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 680, y: 50)
        scoreLabel.zPosition = 500
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
    }
    
    func createTarget() {
        let target = Target()
        target.setup()

        let level = Int.random(in: 0...2)
        var movingRight = true

        switch level {
        case 0:
            // in front of the grass
            target.zPosition = 150
            target.position.y = 280
            target.setScale(0.7)
        case 1:
            // in front of the water background
            target.zPosition = 250
            target.position.y = 190
            target.setScale(0.85)
            movingRight = false
        default:
            // in front of the water foreground
            target.zPosition = 350
            target.position.y = 100
        }

        let move: SKAction
        
        if movingRight {
            target.position.x = 0
            move = SKAction.moveTo(x: 800, duration: targetSpeed)
        } else {
            target.position.x = 800
            target.xScale = -target.xScale
            move = SKAction.moveTo(x: 0, duration: targetSpeed)
        }

        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        target.run(sequence)
        addChild(target)
        
        levelUp()
    }
    
    func levelUp() {
        targetSpeed *= 0.99
        targetDelay *= 0.99
        targetsCreated += 1

        if targetsCreated < 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + targetDelay) { [unowned self] in
                self.createTarget()
            }
        } else {

        }
    }
}
