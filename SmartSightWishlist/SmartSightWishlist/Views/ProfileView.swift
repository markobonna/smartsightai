//
//  ProfileView.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            Text("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
