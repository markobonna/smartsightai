//
//  WishlistView.swift
//  SmartSight
//
//  Created by MarkF on 3/19/23.
//  Copyright © 2023 Gouda Studios. All rights reserved.
//

import SwiftUI
import UIKit
import RealityKit
import VisionKit

class XXXWishlistView: UIViewController, ImageAnalysisInteractionDelegate, UIGestureRecognizerDelegate {


    var listView = MyListView()
    var wishlistButton = UIButton()

    /// LiveText의 구성 요소
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    let soundManager = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(wishlistButton)

        
        createWishlistButton()

        addConstraints()

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

    
    func addConstraints() {
   
        wishlistButton.translatesAutoresizingMaskIntoConstraints = false


        let hideViewConstraints = [
            wishlistButton.topAnchor.constraint(equalTo: view.topAnchor),
            wishlistButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wishlistButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishlistButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
   
        NSLayoutConstraint.activate(hideViewConstraints)
    }

    
    func addGestures() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
    }

    
    private func wishlistRotor () -> UIAccessibilityCustomRotor {
        /// Create a custor Rotor option, it has a name that will be read by voice over, and a action that is a action called when this rotor option is interacted with. The predicate gives you info about the state of this interaction
        let propertyRotor = UIAccessibilityCustomRotor.init(name: "메인 화면으로") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            /// Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.next
            
            /// You can do any kind of business logic processing here
            if forward {
                /// 홈 화면으로 돌아감
                self.dismiss(animated: true)
               /// self.present(WishlistReaderViewController(), animated: true)
            }
            /// Return the selection of voice over to the element rotorPropertyValueLabel. Use this return to select the desired selection that fills the purpose of its logic
            return UIAccessibilityCustomRotorItemResult.init()
        }
        return propertyRotor
    }
    
   
            }

