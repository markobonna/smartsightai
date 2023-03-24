//
//  MainView.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//  Copyright © 2023 Gouda Studios. All rights reserved.
//

import SwiftUI
import CoreData

struct MainView: UIViewControllerRepresentable {
    var managedObjectContext: NSManagedObjectContext

    func makeUIViewController(context: Context) -> MainViewController {
        MainViewController(managedObjectContext: managedObjectContext)
    }

    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
    }
}

