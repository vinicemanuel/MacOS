//
//  ViewController.swift
//  Project_8
//
//  Created by vinicius emanuel on 02/06/22.
//

import Cocoa

class ViewController: NSViewController {
    
    var visualEffectView: NSVisualEffectView!
    var titleView: NSTextField!
    var gridView: NSGridView!
    
    var gridViewButtons = [NSButton]()
    var buttonsArray = [[NSButton]]()
    
    var gameOverView: GameOverView!
    
    var images = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
    var currentLevel = 1
    
    let gridSize = 10
    let gridMargin: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createLevel()
    }
    
    override func loadView() {
        super.loadView()
        
        self.visualEffectView = self.createVisualEfect()
        self.titleView = self.createTitle()
        
        self.buttonsArray = self.createButtonArray()
        self.gridViewButtons = self.buttonsArray.flatMap({$0})
        self.gridView = self.createGridView(rows: self.buttonsArray)
        
        self.view.addSubview(visualEffectView)
        
        self.visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.visualEffectView.addSubview(self.titleView)
        self.titleView.topAnchor.constraint(equalTo: visualEffectView.topAnchor, constant: gridMargin).isActive = true
        self.titleView.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor).isActive = true
        
        self.visualEffectView.addSubview(gridView)
        self.gridView.leadingAnchor.constraint(equalTo: self.visualEffectView.leadingAnchor, constant: gridMargin).isActive = true
        self.gridView.trailingAnchor.constraint(equalTo: self.visualEffectView.trailingAnchor, constant: -gridMargin).isActive = true
        self.gridView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: gridMargin).isActive = true
        self.gridView.bottomAnchor.constraint(equalTo: self.visualEffectView.bottomAnchor, constant: -gridMargin).isActive = true
        
    }
    
    private func createVisualEfect() -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
//        self.visualEffectView.material = .underWindowBackground
        visualEffectView.state = .active
        
        return visualEffectView
    }

    private func createTitle() -> NSTextField {
        let titleString = "Odd One Out"
        let title = NSTextField(labelWithString: titleString)
        title.font = NSFont.systemFont(ofSize: 36, weight: .thin)
        title.textColor = NSColor.labelColor
        title.translatesAutoresizingMaskIntoConstraints = false

        return title
    }
    
    private func createButtonArray() -> [[NSButton]] {
        var rows = [[NSButton]]()

        for _ in 0 ..< gridSize {
            var row = [NSButton]()

            for _ in 0 ..< gridSize {
                let button = NSButton(frame: NSRect(x: 0, y: 0, width: 64, height: 64))
                button.image = NSImage(named: "panda")
                button.setButtonType(.momentaryChange)
                button.imagePosition = .imageOnly
                button.focusRingType = .none
                button.isBordered = false

                button.action = #selector(imageClicked)
                button.target = self

                row.append(button)
            }

            rows.append(row)
        }
        
        return rows
    }
    
    private func createGridView(rows: [[NSView]]) -> NSGridView {
        let gridView = NSGridView(views: rows)

        gridView.translatesAutoresizingMaskIntoConstraints = false

        gridView.columnSpacing = gridMargin / 2
        gridView.rowSpacing = gridMargin / 2

        for i in 0 ..< gridSize {
            gridView.row(at: i).height = 64
            gridView.column(at: i).width = 64
        }
        
        return gridView
    }
    
    private func generateLayout(items: Int) {
        for button in self.gridViewButtons {
            button.tag = 0
            button.image = nil
        }

        self.gridViewButtons.shuffle()
        self.images.shuffle()

        var numUsed = 0
        var itemCount = 1

        let firstButton = self.gridViewButtons[0]
        firstButton.tag = 2 // correct answer
        firstButton.image = NSImage(named: self.images[0])

        for i in 1 ..< items {
            let currentButton = gridViewButtons[i]
            currentButton.tag = 1 // wrong answer
            currentButton.image = NSImage(named: self.images[itemCount])
            numUsed += 1

            if (numUsed == 2) {
                numUsed = 0
                itemCount += 1
            }

            if (itemCount == self.images.count) {
                itemCount = 1
            }
        }
    }
    
    private func gameOver() {
        self.gameOverView = GameOverView()
        self.gameOverView.alphaValue = 0
        self.gameOverView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gameOverView)
        
        self.gameOverView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.gameOverView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.gameOverView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.gameOverView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.gameOverView.layoutSubtreeIfNeeded()
        
        gameOverView.startEmitting()

        NSAnimationContext.current.duration = 1
        gameOverView.animator().alphaValue = 1
    }
    
    private func createLevel() {
        if currentLevel == 9 {
            self.gameOver()
        } else {
//            let numbersOfItems = [0, 5, 15, 25, 35, 49, 65, 81, 100]
            let numbersOfItems = [0, 5, 5, 5, 5, 5, 5, 5, 5]
            generateLayout(items: numbersOfItems[currentLevel])
        }
    }
    
    @objc func imageClicked(_ sender: NSButton) {
        // ignore invisible buttons
        guard sender.tag != 0 else { return }

        if sender.tag == 1 {
            // wrong
            if currentLevel > 1 {
                currentLevel -= 1
            }

            createLevel()
        } else {
            // correct
            if currentLevel < 9 {
                currentLevel += 1
                createLevel()
            }
        }
    }

}

