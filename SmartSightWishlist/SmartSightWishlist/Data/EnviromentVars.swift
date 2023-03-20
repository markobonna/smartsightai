//
//  EnviromentVars.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import Foundation

class EnviromentVars: ObservableObject{
    @Published var createItemSheet: Bool = false
    @Published var editItem: Bool = false
    
    @Published var wishlists: [Wishlist] = []
}
