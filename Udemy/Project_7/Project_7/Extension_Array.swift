//
//  Extension_Array.swift
//  Project_7
//
//  Created by vinicius emanuel on 01/06/22.
//

import Foundation


extension Array {
    
    mutating func moveItem(from: Int, to: Int) {
        let item = self[from]
        self.remove(at: from)
        
        if to <= from {
            self.insert(item, at: to)
        } else {
            self.insert(item, at: to - 1)
        }
    }
}
