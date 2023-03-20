//
//  ContentView.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            TabView{
                
//                ExploreView()
//                    .tabItem{
//                        Text("Explore")
//                        Image(systemName: "magnifyingglass")
//                    }
                
                //My Wishlist View
                MyListView()
                    .tabItem{
                        Text("My SmartSight Wishlist")
                    }
   
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EnviromentVars())
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}


