//
//  CreateListView.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import SwiftUI
import PhotosUI

struct CreateListView: View {
    @State var itemName = ""
    @State var itemPrice = ""
    @State var itemPicture = ""
    @State var itemLink = ""
    @State var itemCurr = "USD"
    @State var itemDesc = ""
    
    let currency = ["USD", "EUR", "JPY", "GBP"]
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false){
                //Stack for all the fields
                VStack{
                    // Item Name Field
                    TextField("Item Name - Required", text: $itemName)
                        .padding(10) //Padding inside the border
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.yellow, lineWidth: 2))
                        .padding(.vertical,10) //Padding that shifts it down
                    
                    HStack{
                        //Currency Field
                        Picker("Select Currency", selection: $itemCurr){
                            ForEach(currency, id: \.self){
                                Text($0)
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.yellow, lineWidth: 2))
                        
                        Spacer()
                        
                        TextField("Price - Required", text: $itemPrice).keyboardType(.decimalPad)
                            .frame(width: UIScreen.screenWidth / 2, height: UIScreen.screenHeight / 30)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.yellow, lineWidth: 2))
                    }
                    .padding(10)
                    
                    
                    Group{
                        
                        TextField("Reason for Item - Optional", text: $itemDesc, axis: .vertical)
                        
                        TextField("Link to Website - Optional", text: $itemLink)
                    }
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.yellow, lineWidth: 2))
                    .padding(.vertical, 10)
                    
                    //Vstack for the photo picker
                    VStack{
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Text("Select a photo")
                                    .padding(10)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    // Retrive selected asset in the form of Data
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                        
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                        }
                        Spacer()
                    }
                    .padding(10)
                    
                    
                    if(itemName != "" && itemPrice != ""){
                        //Create Wishlist Button
                        Button(action:{
                            //Adds the item to your wishlist
                            let newItem = Item(context: moc)
                            newItem.id = UUID()
                            newItem.name = itemName
                            newItem.price = itemPrice
                            newItem.currency = itemCurr
                            newItem.link = itemLink
                            newItem.desc = itemDesc
                            newItem.picture = selectedImageData
                            
                            try? moc.save()
                            
                            //Hides the create view
                            presentationMode.wrappedValue.dismiss()
                            
                            
                        }, label:{
                            Text("Create")
                        })
                        .padding(10)
                        .background(Color.yellow)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                    }
                }
                .padding(20)
                .padding(.top, 30)
            }
            
        }
    }
    
}

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListView()
    }
}


