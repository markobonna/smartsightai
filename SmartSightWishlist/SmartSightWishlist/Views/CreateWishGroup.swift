//
//  CreateWishGroup.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import SwiftUI

struct CreateWishGroup: View {
    @State var wishlistName = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: EnviromentVars
    
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            VStack{
                TextField("Wishlist Name", text: $wishlistName)
                    .padding(10) //Padding inside the border
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.yellow, lineWidth: 2))
                    .padding(.horizontal,10)
                
                if(wishlistName != ""){
                    Button("Create"){
                        data.wishlists.append(Wishlist(name: wishlistName))
                        
                        presentationMode.wrappedValue.dismiss()
                        
                        
                    }
                }
            }
        }
    }
}

struct CreateWishGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateWishGroup()
            .environmentObject(EnviromentVars())
    }
}
