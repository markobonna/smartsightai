//
//  Wishlist.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import SwiftUI

struct Wishlist: Identifiable {
    var id = UUID()
    var name: String
    
    init(name: String) {
        self.name = name
    }
  
}
