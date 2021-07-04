//
//  Pin.swift
//  Project_5
//
//  Created by Vinicius Emanuel on 04/07/21.
//

import Cocoa
import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var color: NSColor
    
    init(title: String?, coordinate: CLLocationCoordinate2D, color: NSColor = NSColor.green) {
        self.title = title
        self.coordinate = coordinate
        self.color = color
    }
}
