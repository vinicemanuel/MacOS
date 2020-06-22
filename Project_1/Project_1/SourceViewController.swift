//
//  SourceViewController.swift
//  Project_1
//
//  Created by Vinicius Emanuel on 19/06/20.
//  Copyright © 2020 Vinicius Emanuel. All rights reserved.
//

import Cocoa

class SourceViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    var pictures: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
    }
    
    private func loadData(){
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.resourcePath!) else { return }
        
        for item in items{
            if item.hasPrefix("nssl"){
                self.pictures.append(item)
            }
        }
    }
}

extension SourceViewController: NSTableViewDataSource, NSTableViewDelegate{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.pictures.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let view = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {return nil}
        
        view.textField?.stringValue = pictures[row]
        return view
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else { return }
        guard let splitVC = parent as? NSSplitViewController else { return }
        
        if let detail = splitVC.children.last as? DetailViewController{
            detail.selectImage(name: self.pictures[tableView.selectedRow])
        }
    }
}
