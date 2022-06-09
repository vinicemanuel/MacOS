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
    
    var currentMatches = Set<Ball>()
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal

            if let formattedScore = formatter.string(from: score as NSNumber) {
                scoreLabel.text = "Score: \(formattedScore)"
            }
        }
    }
    
    var timer: SKShapeNode!
    var gameStartTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        for x in 0 ..< ballsPerRow {
            var col = [Ball]()

            for y in 0 ..< ballsPerColumn {
                let ball = createBall(row: y, col: x, startOffScreen: true)
                col.append(ball)
            }

            cols.append(col)
        }
        
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 55, y: frame.maxY - 55)
        addChild(scoreLabel)
        
        timer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 40))
        timer.fillColor = NSColor.green
        timer.strokeColor = NSColor.clear
        timer.position = CGPoint(x: 545, y: 539)
        addChild(timer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStartTime == 0 {
            gameStartTime = currentTime
        }

        let elapsed = (currentTime - gameStartTime)
        let remaining = 100 - elapsed
        timer.xScale = max(0, CGFloat(remaining) / 100)
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

            let action = SKAction.move(to: finalPosition, duration: 0.4)

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
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        guard let clickedBall = ball(at: location) else { return }

        isUserInteractionEnabled = false
        currentMatches.removeAll()
        match(ball: clickedBall)

        // make sure we remove higher-up balls first
        let sortedMatches = currentMatches.sorted {
            $0.row > $1.row
        }

        // remove all matched balls
        for match in sortedMatches {
            destroy(match)
        }
        
        // move down any balls that need it
        for (columnIndex, col) in cols.enumerated() {
            for (rowIndex, ball) in col.enumerated() {
                ball.row = rowIndex

                let action = SKAction.move(to: position(for: ball), duration: 0.4)
                ball.run(action)
            }

            // create as many new balls as we need
            while cols[columnIndex].count < ballsPerColumn {
                let ball = createBall(row: cols[columnIndex].count, col: columnIndex, startOffScreen: true)
                cols[columnIndex].append(ball)
            }
        }
        
        let newScore = currentMatches.count
        
        if newScore == 1 {
            score -= 1000
        } else if newScore == 2 {
            // no change
        } else {
            let scoreToAdd = pow(2, Double(min(newScore, 16)))
            score += Int(scoreToAdd)
        }
    }
    
    func position(for ball: Ball) -> CGPoint {
        let x = 72 + ballSize * CGFloat(ball.col)
        let y = 50 + ballSize * CGFloat(ball.row)
        return CGPoint(x: x, y: y)
    }
    
    func ball(at point: CGPoint) -> Ball? {
        let balls = nodes(at: point).compactMap { $0 as? Ball }
        return balls.first
    }
    
    func match(ball originalBall: Ball) {
        var checkBalls = [Ball?]()

        currentMatches.insert(originalBall)
        let pos = originalBall.position

        checkBalls.append(ball(at: CGPoint(x: pos.x, y: pos.y - ballSize)))
        checkBalls.append(ball(at: CGPoint(x: pos.x, y: pos.y + ballSize)))
        checkBalls.append(ball(at: CGPoint(x: pos.x - ballSize, y: pos.y)))
        checkBalls.append(ball(at: CGPoint(x: pos.x + ballSize, y: pos.y)))

        for case let check? in checkBalls {
            if currentMatches.contains(check) { continue }

            if check.name == originalBall.name {
                match(ball: check)
            }
        }
    }
    
    func destroy(_ ball: Ball) {
        cols[ball.col].remove(at: ball.row)
        ball.removeFromParent()
    }
}
