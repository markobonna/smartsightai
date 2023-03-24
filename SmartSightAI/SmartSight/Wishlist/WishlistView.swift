//
//  WishlistView.swift
//  SmartSight
//
//  Created by MarkF on 3/19/23.
//

import SwiftUI
import UIKit
import RealityKit
import VisionKit

// SwiftUI View
struct MyWishlistView: View {
    var body: some View {
        ZStack{
            Color("Background")
                .ignoresSafeArea()
            MyListView()
        }
    }
}

// UIKit UIViewController
class WishlistView: UIViewController, ImageAnalysisInteractionDelegate, UIGestureRecognizerDelegate {
    
    var wishlistButton = UIButton()

    /// LiveText components
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    let soundManager = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: MyWishlistView())
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        self.view.addSubview(wishlistButton)

        createWishlistButton()
        addConstraints(hostingController.view)
        addGestures()
        let wishlistRotor = self.wishlistRotor()
        self.accessibilityCustomRotors = [wishlistRotor]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.soundManager.stopSpeak()
    }

    func createWishlistButton() {
        wishlistButton.setTitle(Language(rawValue: "")?.localized, for: .normal)
        wishlistButton.setTitle("", for: .selected)
    }

    func addConstraints(_ hostingView: UIView) {
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        wishlistButton.translatesAutoresizingMaskIntoConstraints = false

        let hostingViewConstraints = [
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        let hideViewConstraints = [
            wishlistButton.heightAnchor.constraint(equalToConstant: 60),
            wishlistButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            wishlistButton.widthAnchor.constraint(equalToConstant: 60),
            wishlistButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(hostingViewConstraints)
        NSLayoutConstraint.activate(hideViewConstraints)
    }

    func addGestures() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
    }

    private func wishlistRotor() -> UIAccessibilityCustomRotor {
        let propertyRotor = UIAccessibilityCustomRotor.init(name: "메인 화면으로") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            let forward = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.next
            
            if forward {
                self.dismiss(animated: true)
            }
            return UIAccessibilityCustomRotorItemResult.init()
        }
        return propertyRotor
    }
}
