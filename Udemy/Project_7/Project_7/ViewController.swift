//
//  ViewController.swift
//  Project_7
//
//  Created by Vinicius Emanuel on 22/07/21.
//

import Cocoa
import AVFoundation

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
    
    override func keyUp(with event: NSEvent) {
        //check delete button
        if event.charactersIgnoringModifiers != String(UnicodeScalar(NSDeleteCharacter)!) { return }
        
        let selectionIndexPath = self.collectionView.selectionIndexPaths.sorted().reversed()
        if selectionIndexPath.count > 0 {
            let fm = FileManager.default
            
            for indexPath in selectionIndexPath {
                do {
                    try fm.trashItem(at: self.photos[indexPath.item], resultingItemURL: nil)
                    self.photos.remove(at: indexPath.item)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            self.collectionView.animator().deleteItems(at: self.collectionView.selectionIndexPaths)
        }
    }
    
    @IBAction func runExport(_ sender: NSMenuItem) {
        let size: CGSize

        if sender.tag == 720 {
            size = CGSize(width: 1280, height: 720)
        } else {
            size = CGSize(width: 1920, height: 1080)
        }

        do {
            try exportMovie(at: size)
        } catch {
            print("Error")
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
    
    private func performInternalDrag(with items: [IndexPath], to indexPath: IndexPath) {
        var targetIndex = indexPath.item
        
        for fromIndexPath in items {
            let fromItemIndex = fromIndexPath.item
            //move towards front
            if (fromItemIndex > targetIndex) {
                self.photos.moveItem(from: fromItemIndex, to: targetIndex)
                self.collectionView.moveItem(at: IndexPath(item: fromItemIndex, section: 0), to: IndexPath(item: targetIndex, section: 0))
                targetIndex += 1
            }
        }
        
        targetIndex = indexPath.item - 1
        
        for fromIndexPath in items.reversed() {
            let fromItemIndex = fromIndexPath.item
            //move towards back
            if (fromItemIndex < targetIndex) {
                self.photos.moveItem(from: fromItemIndex, to: targetIndex)
                collectionView.moveItem(at: IndexPath(item: fromItemIndex, section: 0), to: IndexPath(item: targetIndex, section: 0))
                targetIndex -= 1
            }
        }
    }

    private func performExternalDrag(with items: [NSPasteboardItem], at indexPath: IndexPath) {
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
    
    private func exportMovie(at size: NSSize) throws {
        let videoDuration = 8.0
        let timeRange = CMTimeRange(start: .zero, duration: CMTime(seconds: videoDuration, preferredTimescale: 600))

        let savePath = photosDirectory.appendingPathComponent("video.mp4")
        let fm = FileManager.default

        if fm.fileExists(atPath: savePath.path) {
            try fm.removeItem(at: savePath)
        }

        let mutableComposition = AVMutableComposition()
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = size
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)

        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        parentLayer.addSublayer(createVideoLayer(in: parentLayer, composition: mutableComposition, videoComposition: videoComposition, timeRange: timeRange))
        parentLayer.addSublayer(createSlideshow(frame: parentLayer.frame, duration: videoDuration))
        parentLayer.addSublayer(createText(frame: parentLayer.frame))

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = timeRange
        videoComposition.instructions = [instruction]

        let exportSession = AVAssetExportSession(asset: mutableComposition, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = savePath
        exportSession.videoComposition = videoComposition
        exportSession.outputFileType = .mp4

        exportSession.exportAsynchronously { [unowned self] in
            DispatchQueue.main.async {
                self.exportFinished(error: exportSession.error)
            }
        }
    }
    
    private func createVideoLayer(in parentLayer: CALayer, composition: AVMutableComposition, videoComposition: AVMutableVideoComposition, timeRange: CMTimeRange) -> CALayer {
        let videoLayer = CALayer()
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)

        let mutableCompositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let trackURL = Bundle.main.url(forResource: "black", withExtension:"mp4")!
        let asset = AVAsset(url: trackURL)
        let track = asset.tracks[0]
        try! mutableCompositionVideoTrack?.insertTimeRange(timeRange, of: track, at: .zero)

        return videoLayer
    }
    
    private func createSlideshow(frame: CGRect, duration: CFTimeInterval) -> CALayer {
        let imageLayer = CALayer()
        imageLayer.bounds = frame
        imageLayer.position = CGPoint(x: imageLayer.bounds.midX, y: imageLayer.bounds.midY)
        imageLayer.contentsGravity = .resizeAspectFill

        let fadeAnim = CAKeyframeAnimation(keyPath: "contents")
        fadeAnim.duration = duration
        fadeAnim.isRemovedOnCompletion = false
        fadeAnim.beginTime = AVCoreAnimationBeginTimeAtZero

        var values = [NSImage]()

        for photo in self.photos {
            if let image = NSImage(contentsOfFile: photo.path) {
                values.append(image)
            }
        }

        fadeAnim.values = values
        imageLayer.add(fadeAnim, forKey: nil)

        return imageLayer
    }
    
    private func createText(frame: CGRect) -> CALayer {
        let attrs = [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: NSColor.green]
        let text = NSAttributedString(string: "Copyright © 2017 Hacking with Swift", attributes: attrs)
        let textSize = text.size()

        let textLayer = CATextLayer()
        textLayer.bounds = CGRect(origin: CGPoint.zero, size: textSize)
        textLayer.anchorPoint = CGPoint(x: 1, y: 1)
        textLayer.position = CGPoint(x: frame.maxX - 10, y: textSize.height + 10)
        textLayer.string = text
        textLayer.display() // force the layer to render immediately!

        return textLayer
    }
    
    private func exportFinished(error: Error?) {
        let message: String

        if let error = error  {
            message = "Error: \(error.localizedDescription)"
        } else {
            message = "Success!"
        }

        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
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
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        return photos[indexPath.item] as NSPasteboardWriting?
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
