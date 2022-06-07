//
//  GameView.swift
//  Project_14
//
//  Created by vinicius emanuel on 07/06/22.
//

import SpriteKit

class GameView: SKView {
    override func resetCursorRects() {
        if let targetImage = NSImage(named: "cursor") {
            let cursor = NSCursor(image: targetImage, hotSpot: CGPoint(x: targetImage.size.width / 2, y: targetImage.size.height / 2))
            addCursorRect(frame, cursor: cursor)
        }
    }
}

