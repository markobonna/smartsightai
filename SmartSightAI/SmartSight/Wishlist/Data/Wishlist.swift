//
//  Wishlist.swift
//  WishApp
//
//  Created by Marcus Moore on 1/25/23.
//

import SwiftUI

struct Wishlist: Identifiable {
    var id = UUID()
    var name: String
    
    init(name: String) {
        self.name = name
    }
  
}
