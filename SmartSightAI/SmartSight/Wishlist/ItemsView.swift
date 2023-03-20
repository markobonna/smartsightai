//
//  ItemsView.swift
//  SmartSight
//
//  Created by MarkF on 3/19/23.
//  Copyright © 2023 Gouda Studios. All rights reserved.
//

import SwiftUI

struct ItemsView: View {
    @State var createNew: Bool = false
    @State var presentAlert: Bool = false
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @Environment(\.managedObjectContext) var moc
    
    
    @EnvironmentObject var data: EnviromentVars
    
    @State var wishlistTitle: String = ""
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(moc.delete)
            
            do {
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
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
                        Button(action: {
                            print("Help")
                        }, label: {
                            Image(systemName: "questionmark.circle")
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            createNew = true
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .sheet(isPresented: $createNew){
                            CreateListView()
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
                    
                    
                    
                    Spacer()
                }
                .padding(30)
                .navigationBarTitle("Wishlists")
            }
        }
    }
}



struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
            .environmentObject(EnviromentVars())
    }
}
