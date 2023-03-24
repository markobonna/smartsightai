//
//  MyListView.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import UIKit
import SwiftUI
import CoreData


struct MyListView: View {
    @State var createNew: Bool = false
    @State var presentAlert: Bool = false
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @Environment(\.managedObjectContext) var managedObjectContext
    
   
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            managedObjectContext.delete(item)
        }
        try? managedObjectContext.save()
    }

    
    func submit() {
        print("You entered")
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("Background")
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        
                        
                        Spacer()
                        
                        Button("New Wishlist Item"){
                            createNew = true
                        }
                        
                            
                    
                        .sheet(isPresented: $createNew){
                            CreateListView(managedObjectContext: managedObjectContext)
                        }
                        
                        .sheet(isPresented: $presentAlert) {
                            CreateWishGroup()
                                .presentationDetents([.medium])
                        }
                        
                        
                    }
                    List{
                        ForEach(items) {item in
                            VStack{
                                //Takes you to the view that shows you more details
                                NavigationLink(destination: DetailView(itemName: item.name!, itemPrice: item.price!, itemPicture: item.picture ,itemLink: item.link ?? "", itemCurr: item.currency!, itemDesc: item.desc ?? "")){
                                    
                                    //Displays CardView
                                    CardView(itemName: item.name!, itemPrice: item.price!, itemPicture: item.picture ,itemLink: item.link ?? "", itemCurr: item.currency!, itemDesc: item.desc ?? "")
                                }
                            }
                            .listRowBackground(Color("DarkerBackground"))
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    
//                    List(data.wishlists) { wishlist in
//                        WishlistCard(name: wishlist.name)
//                    }
                    
                    Spacer()
                }
                .padding(30)
                .navigationBarTitle("SmartSight Wishlist")
            }
        }
    }
}


