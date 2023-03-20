//
//  WishlistCard.swift
//  SmartSight
//
//  Created by MarkF on 3/19/23.
//  Copyright © 2023 Gouda Studios. All rights reserved.
//

import SwiftUI

struct WishlistCard: View {
    @EnvironmentObject var data: EnviromentVars
    
    var name: String
    
    var body: some View {
        Text("\(name) List")
            .frame(width: 170, height: 100)
            
            .padding(10)
            .background(.blue)
            .cornerRadius(20)
            
        
    }
}

struct WishlistCard_Previews: PreviewProvider {
    static var previews: some View {
        WishlistCard(name: "Christmas")
            .environmentObject(EnviromentVars())
    }
}
