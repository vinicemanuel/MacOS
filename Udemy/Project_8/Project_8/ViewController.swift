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
    
    let gridSize = 10
    let gridMargin: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @objc func imageClicked(_ sender: NSButton) {
//        // ignore invisible buttons
//        guard sender.tag != 0 else { return }
//
//        if sender.tag == 1 {
//            // wrong
//            if currentLevel > 1 {
//                currentLevel -= 1
//            }
//
//            createLevel()
//        } else {
//            // correct
//            if currentLevel < 9 {
//                currentLevel += 1
//                createLevel()
//            }
//        }
    }

}

