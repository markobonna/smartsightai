//
//  EnviromentVars.swift
//  WishApp
//
//  Created by Marcus Moore on 12/29/22.
//

import Foundation

class EnviromentVars: ObservableObject{
    @Published var createItemSheet: Bool = false
    @Published var editItem: Bool = false
    
    @Published var wishlists: [Wishlist] = []
}
