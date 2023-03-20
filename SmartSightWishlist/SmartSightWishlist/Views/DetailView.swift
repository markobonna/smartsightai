//
//  DetailView.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import SwiftUI

struct DetailView: View {
    // var wishlist: WishListItem
    
    var itemName: String
    var itemPrice: String
    var itemPicture: Data?
    var itemLink: String
    var itemCurr: String
    var itemDesc: String
    @EnvironmentObject var data: EnviromentVars
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("Background")
                    .ignoresSafeArea()
                VStack{
                    ScrollView(.vertical, showsIndicators: false){
                        
                        VStack{
                            if(itemPicture == nil){
                                Image("noImage")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 5)      
                                
                            }else {
                                Image(uiImage: UIImage(data: itemPicture!)!)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            
                            HStack{
                                Text("Price: ")
                                Text(Double(itemPrice)!, format: .currency(code: itemCurr))
                                
                                Spacer()
                                
                                if(itemLink == ""){
                                    
                                } else if(verifyUrl(urlString: itemLink) == false){
                                    Text("Invalid link. Edit item to fix the link")
                                        .foregroundColor(Color.yellow)
                                } else {
                                    Link("Click to view link", destination: URL(string: itemLink)!)
                                        .foregroundColor(Color.yellow)
                                }
                            }
                            .padding(10)
                            
                            Group{
                                if(itemDesc != ""){
                                    HStack{
                                        Text("Reason for the item:")
                                        Spacer()
                                    }
                                    .padding(10)
                                    Text(itemDesc)
                                        .padding(15)
                                        .background(Color("DarkerBackground"))
                                    //.opacity(0.6)
                                        .cornerRadius(10)
                                }
                            }
                            
                            //Spacer()
                        }
                    }
                }
                .navigationBarTitle(itemName)
                .navigationBarTitleDisplayMode(.inline)
                .padding(20)
            }
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(itemName: "Funko", itemPrice: "15.99", itemPicture: nil, itemLink: "https://www.hackingwithswift.com/quick-start/swiftui", itemCurr: "USD", itemDesc: "This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop This is a funko pop")
            .environmentObject(EnviromentVars())
        
    }
}
