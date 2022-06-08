//
//  GameScene.swift
//  Project_17
//
//  Created by vinicius emanuel on 08/06/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var nextBall = GKShuffledDistribution(lowestValue: 0, highestValue: 3)
    var cols = [[Ball]]()
    let ballSize: CGFloat = 50
    let ballsPerColumn = 10
    let ballsPerRow = 14
    
    override func didMove(to view: SKView) {
        for x in 0 ..< ballsPerRow {
            var col = [Ball]()

            for y in 0 ..< ballsPerColumn {
                let ball = createBall(row: y, col: x, startOffScreen: true)
                col.append(ball)
            }

            cols.append(col)
        }
       
    }
    
    func createBall(row: Int, col: Int, startOffScreen: Bool = false) -> Ball {
        let ballImages = ["ballBlue", "ballGreen", "ballPurple", "ballRed"]
        let ballImage = ballImages[nextBall.nextInt()]

        let ball = Ball(imageNamed: ballImage)
        ball.row = row
        ball.col = col

        if startOffScreen {
            let finalPosition = position(for: ball)
            ball.position = finalPosition
            ball.position.y += 600

            let action = SKAction.move(to: finalPosition, duration: 0.6)

            ball.run(action) { [unowned self] in
                self.isUserInteractionEnabled = true
            }
        } else {
            ball.position = position(for: ball)
        }

        ball.name = ballImage
        addChild(ball)

        return ball
    }
    
    func position(for ball: Ball) -> CGPoint {
        let x = 72 + ballSize * CGFloat(ball.col)
        let y = 50 + ballSize * CGFloat(ball.row)
        return CGPoint(x: x, y: y)
    }
}
