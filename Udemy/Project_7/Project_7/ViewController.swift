//
//  ViewController.swift
//  Project_7
//
//  Created by Vinicius Emanuel on 22/07/21.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    var photos = [URL]()
    var itemsBeingDragged: Set<IndexPath>?
    
    lazy var photosDirectory: URL = {
        let fm = FileManager.default
        var paths = fm.urls(for: .documentDirectory, in: .userDomainMask)
        var saveDirectory = paths[0]
        saveDirectory.appendPathComponent("SlideMark")
        print(saveDirectory.path)
        
        if fm.fileExists(atPath: saveDirectory.path) == false {
            try? fm.createDirectory(at: saveDirectory, withIntermediateDirectories: true)
        }
        
        return saveDirectory
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerForDraggedTypes([.URL, .fileURL])
        
        self.photos = self.loadPhotos()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func loadPhotos() -> [URL] {
        do {
            let fm = FileManager.default
            var files = try fm.contentsOfDirectory(at: self.photosDirectory, includingPropertiesForKeys: nil)
            files.removeAll(where: {$0.pathExtension != "jpg" && $0.pathExtension != "png"})
            
            return files
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func performInternalDrag(with items: [IndexPath], to indexPath: IndexPath) {
        
    }

    func performExternalDrag(with items: [NSPasteboardItem], at indexPath: IndexPath) {
        let fm = FileManager.default
        
        for item in items {
            guard let stringURL = item.string(forType: NSPasteboard.PasteboardType(kUTTypeFileURL as String)) else { continue }
            guard let sourceURL = URL(string: stringURL) else { continue }
            let destinationURL = photosDirectory.appendingPathComponent(sourceURL.lastPathComponent)

            do {
                try fm.copyItem(at: sourceURL, to: destinationURL)
            } catch {
                print(error.localizedDescription)
            }

            self.photos.insert(destinationURL, at: indexPath.item)
            self.collectionView.insertItems(at: [indexPath])
        }

    }
    
    //MARK: - NSCollectionViewDelegate
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        self.itemsBeingDragged = indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        self.itemsBeingDragged = nil
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        if let moveItems = itemsBeingDragged?.sorted() {
            //internal
            self.performInternalDrag(with: moveItems, to: indexPath)
        } else {
            //external
            let pasteboard = draggingInfo.draggingPasteboard
            guard let items = pasteboard.pasteboardItems else { return true }
            self.performExternalDrag(with: items, at: indexPath)
        }
        
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
        return .move
    }
    
    //MARK: - NSCollectionViewDataSource
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PhotoCell"), for: indexPath)
        guard let pictureItem = item as? PhotoCell else {
            return item
        }
        
        pictureItem.imageView?.image = NSImage(contentsOf: self.photos[indexPath.item])
        
        return pictureItem
    }
}

