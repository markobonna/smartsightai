//
//  WishAppApp.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import SwiftUI

@main
struct WishAppApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(EnviromentVars())
        }
    }
}
