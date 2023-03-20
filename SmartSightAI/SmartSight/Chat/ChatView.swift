//
//  ChatView.swift
//  SmartSight
//
//  Created by MarkF on 3/19/23.
//  Copyright © 2023 Gouda Studios. All rights reserved.
//

import UIKit
import RealityKit
import VisionKit
import WebKit

class ChatView: UIViewController, ImageAnalysisInteractionDelegate, UIGestureRecognizerDelegate {
    
    var webView = WKWebView()
    var chatButton = UIButton()
    
    
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    let soundManager = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load your Gradio Link
               if let url = URL(string: "https://121dd02734c2182799.gradio.live") {
                   let request = URLRequest(url: url)
                   webView.load(request)
               }

        self.view.addSubview(chatButton)
        self.view.insertSubview(webView, belowSubview: chatButton)

        createChatButton()

        addConstraints()

        addGestures()
        let chatRotor = self.chatRotor()
        self.accessibilityCustomRotors = [chatRotor]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.soundManager.stopSpeak()
        
        
    }

    func createChatButton() {
        chatButton.setTitle(Language(rawValue: "")?.localized, for: .normal)
        chatButton.setTitle("", for: .selected)
        
    }

    func addConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false

        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        let hideViewConstraints = [
            chatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            chatButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            chatButton.widthAnchor.constraint(equalToConstant: 60), // Set a fixed width
            chatButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(hideViewConstraints)
    }

    func addGestures() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
    }

    
    private func chatRotor () -> UIAccessibilityCustomRotor {
        /// Create a custor Rotor option, it has a name that will be read by voice over, and a action that is a action called when this rotor option is interacted with. The predicate gives you info about the state of this interaction
        let propertyRotor = UIAccessibilityCustomRotor.init(name: "메인 화면으로") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            /// Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.next
            
            /// You can do any kind of business logic processing here
            if forward {
                /// 홈 화면으로 돌아감
                self.dismiss(animated: true)
               /// self.present(ChatReaderViewController(), animated: true)
            }
            /// Return the selection of voice over to the element rotorPropertyValueLabel. Use this return to select the desired selection that fills the purpose of its logic
            return UIAccessibilityCustomRotorItemResult.init()
        }
        return propertyRotor
    }
    
    
        }
    


