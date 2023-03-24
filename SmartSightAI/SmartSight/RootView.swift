//
//  RootView.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//  Copyright © 2023 Gouda Studios. All rights reserved.
//

import SwiftUI
import CoreData

struct RootView: UIViewControllerRepresentable {
    var managedObjectContext: NSManagedObjectContext

    func makeUIViewController(context: Context) -> some UIViewController {
        MainViewController(managedObjectContext: managedObjectContext)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

