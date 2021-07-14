//
//  ViewController.swift
//  Project_6
//
//  Created by Vinicius Emanuel on 05/07/21.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.createVFL()
//        self.creadAnchors()
//        self.createStackView()
        self.createGridView()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func makeView(_ number: Int) -> NSView {
        let view = NSTextField(labelWithString: "view #\(number)")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.wantsLayer = true
        view.textColor = .systemRed
        view.layer?.backgroundColor = NSColor.cyan.cgColor
        return view
    }
    
    func createVFL() {
        let textFields = ["View0": self.makeView(0),
                          "View1": self.makeView(1),
                          "View2": self.makeView(2),
                          "View3": self.makeView(3)]
        
        for (name, textField) in textFields {
            self.view.addSubview(textField)
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(name)]|", options: [], metrics: nil, views: textFields))
        }
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[View0]-[View1]-[View2]-[View3]|", options: [], metrics: nil, views: textFields))
    }
    
    func creadAnchors() {
        var previous: NSView!
        
        let views = [makeView(0), makeView(1), makeView(2), makeView(3)]
        
        for vw in views {
            self.view.addSubview(vw)
            vw.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            vw.heightAnchor.constraint(equalToConstant: 88).isActive = true
            vw.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            
            if previous != nil {
                vw.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                vw.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            }
            
            previous = vw
        }
        
        previous.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func createStackView() {
        let stackView = NSStackView(views: [makeView(0), makeView(1), makeView(2), makeView(3)])
        stackView.distribution = .fillEqually
        stackView.orientation = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        for view in stackView.arrangedSubviews {
            view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .horizontal)
            view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .vertical)
        }
        
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func createGridView() {
        let empty = NSGridCell.emptyContentView
        
        let gridView = NSGridView(views: [
            [makeView(0)],
            [makeView(1), empty,       makeView(2)],
            [makeView(3), makeView(4), makeView(5),  makeView(6)],
            [makeView(7), empty,       makeView(8)],
            [makeView(9)]
        ])
        
        gridView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gridView)
        
        gridView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gridView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gridView.row(at: 0).height = 32
        gridView.row(at: 1).height = 32
        gridView.row(at: 2).height = 32
        gridView.row(at: 3).height = 32
        gridView.row(at: 4).height = 32
        
        gridView.column(at: 0).width = 128
        gridView.column(at: 1).width = 128
        gridView.column(at: 2).width = 128
        gridView.column(at: 3).width = 128
        
        gridView.row(at: 0).mergeCells(in: NSRange(location: 0, length: 4))
        gridView.row(at: 1).mergeCells(in: NSRange(location: 0, length: 2))
        gridView.row(at: 1).mergeCells(in: NSRange(location: 2, length: 2))
        gridView.row(at: 3).mergeCells(in: NSRange(location: 0, length: 2))
        gridView.row(at: 3).mergeCells(in: NSRange(location: 2, length: 2))
        gridView.row(at: 4).mergeCells(in: NSRange(location: 0, length: 4))
        
        gridView.row(at: 0).yPlacement = .center
        gridView.row(at: 1).yPlacement = .center
        gridView.row(at: 2).yPlacement = .center
        gridView.row(at: 3).yPlacement = .center
        gridView.row(at: 4).yPlacement = .center
        gridView.column(at: 0).xPlacement = .center
        gridView.column(at: 1).xPlacement = .center
        gridView.column(at: 2).xPlacement = .center
        gridView.column(at: 3).xPlacement = .center
    }
}

