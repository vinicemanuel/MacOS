//
//  Target.swift
//  Project_14
//
//  Created by vinicius emanuel on 07/06/22.
//

import Foundation
import SpriteKit

class Target: SKNode {
    var target: SKSpriteNode!
    var stick: SKSpriteNode!
    
    func setup() {
        let stickType = Int.random(in: 0...2)
        let targetType = Int.random(in: 0...3)

        stick = SKSpriteNode(imageNamed: "stick\(stickType)")
        target = SKSpriteNode(imageNamed: "target\(targetType)")

        target.name = "target"
        target.position.y += 116

        addChild(stick)
        addChild(target)
    }
}
