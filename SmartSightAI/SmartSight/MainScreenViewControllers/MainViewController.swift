//
//  MainViewController.swift
//  SmartSight
//
//  Created by MarkF on 3/17/23.
//

import UIKit
import Foundation
import AVFoundation
import Vision
import ARKit
import CoreData
import SwiftUI

public let languageSetting = Locale.current.language.languageCode!.identifier
let supportLiDAR = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)

class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let managedObjectContext: NSManagedObjectContext

        init(managedObjectContext: NSManagedObjectContext) {
            self.managedObjectContext = managedObjectContext
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    var selected = 0

    /// Variable for UI Button
    lazy var navigationButton = UIButton()
    lazy var textReaderButton = UIButton()
    lazy var chatButton = UIButton()
    lazy var wishlistButton = UIButton()
    lazy var settingButton = UIButton()
    var fontSize: CGFloat = 50
    
    /// Variable for object detection camera view
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil

    /// Varibale for Custom Rotor
    var rotorPropertyValueLabel: UILabel!
    
    private var previewView: UIView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 처음 앱을 작동시켰을때 healthKit Manager에서 사용자의 보폭 정보를 불러오기 위한 시험 코드입니다.
        // print(healthKitManager.calToStepCount(meter: 10))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(navigationButton)
  
        self.view.addSubview(textReaderButton)
        self.view.addSubview(chatButton)
        self.view.addSubview(wishlistButton)
        self.view.addSubview(settingButton)
        
        let navigationButtonRotor = self.navigationButtonRotor()
        let textReaderButtonRotor = self.textReaderButtonRotor()
        let chatButtonRotor = self.chatButtonRotor()
        let wishlistButtonRotor = self.wishlistButtonRotor()
        self.accessibilityCustomRotors = [navigationButtonRotor, textReaderButtonRotor, wishlistButtonRotor, chatButtonRotor]

        createNavigateButton()
        createTextReaderButton()
        createChatButton()
        createWishlistButton()
        


        addConstraints()
        
        if !UserDefaults.standard.bool(forKey: "lanchedBefore") {  
            UserDefaults.standard.set(true, forKey: "lanchedBefore")
            UserDefaults.standard.setValue(Float(0.4), forKey: "speakingRate")
        }
    }

    func createNavigateButton() {
        navigationButton.backgroundColor = UIColor.yellow
        navigationButton.setTitleColor(.black, for: .normal)
        navigationButton.setTitle(Language(rawValue: "Navigation")?.localized, for: .normal)
        navigationButton.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        navigationButton.layer.cornerRadius = 10.0
        navigationButton.tag = 1
        navigationButton.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        navigationButton.layer.cornerRadius = 10.0
        navigationButton.layer.borderWidth = 10
        navigationButton.layer.borderColor = UIColor.white.cgColor
    }

    func createTextReaderButton() {
        textReaderButton.backgroundColor = UIColor.purple
        textReaderButton.setTitleColor(.white, for: .normal)
        textReaderButton.setTitle(Language(rawValue: "Text Reader")?.localized, for: .normal)
        textReaderButton.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        textReaderButton.layer.cornerRadius = 10.0
        textReaderButton.tag = 2
        textReaderButton.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        textReaderButton.layer.cornerRadius = 10.0
        textReaderButton.layer.borderWidth = 10
        textReaderButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func createChatButton() {
        chatButton.backgroundColor = UIColor.orange
        chatButton.setTitleColor(.black, for: .normal)
        chatButton.setTitle(Language(rawValue: "Chat")?.localized, for: .normal)
        chatButton.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        chatButton.layer.cornerRadius = 0.5 * min(view.frame.width, view.frame.height) * 0.25
        chatButton.tag = 3
        chatButton.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        chatButton.layer.cornerRadius = 10.0
        chatButton.layer.borderWidth = 10
        chatButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func createWishlistButton() {
        wishlistButton.backgroundColor = UIColor.blue
        wishlistButton.setTitleColor(.white, for: .normal)
        wishlistButton.setTitle(Language(rawValue: "Wishlist")?.localized, for: .normal)
        wishlistButton.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        wishlistButton.layer.cornerRadius = 10.0
        wishlistButton.tag = 4
        wishlistButton.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        wishlistButton.layer.cornerRadius = 10.0
        wishlistButton.layer.borderWidth = 10
        wishlistButton.layer.borderColor = UIColor.white.cgColor
    }



    func addConstraints() {
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        textReaderButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        wishlistButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false

        let navigationButtonConstraints = [
            navigationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,  constant: self.view.frame.height * 0.050),
            navigationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: self.view.frame.height * -0.500),
            navigationButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: self.view.frame.width * 0.0500),
            navigationButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: self.view.frame.width * -0.51),
            
        ]


        let textReaderButtonConstraints = [
            textReaderButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height * 0.050),
            textReaderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: self.view.frame.height * -0.500),
            textReaderButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: self.view.frame.width * 0.51),
            textReaderButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: self.view.frame.width * -0.0500),
            
        ]
        
        let chatButtonConstraints = [
            chatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height * 0.500),
            chatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,  constant: self.view.frame.height * -0.050),
            chatButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: self.view.frame.width * 0.0500),
            chatButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: self.view.frame.width * -0.51),
            
        ]
        
        let wishlistButtonConstraints = [
            wishlistButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height * 0.500),
            wishlistButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,  constant: self.view.frame.height * -0.050),
            wishlistButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: self.view.frame.width * 0.51),
            wishlistButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: self.view.frame.width * -0.0500),
            
        ]
        
 

        NSLayoutConstraint.activate(navigationButtonConstraints)
        NSLayoutConstraint.activate(textReaderButtonConstraints)
        NSLayoutConstraint.activate(chatButtonConstraints)
        NSLayoutConstraint.activate(wishlistButtonConstraints)

    }

    // MARK: Switching Button Custom Rotor
    public func navigationButtonRotor() -> UIAccessibilityCustomRotor {
           
           /// Create a custor Rotor option, it has a name that will be read by voice over, and a action that is a action called when this rotor option is interacted with. The predicate gives you info about the state of this interaction
           let propertyRotorOption = UIAccessibilityCustomRotor.init(name: "내비게이션") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
               
               /// Get the direction of the movement when this rotor option is enablade
               let forward = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.next
               
               /// You can do any kind of business logic processing here
               if forward {
                   self.selected = 1
                   self.onTouchButton(self.navigationButton)
               }
               
               /// Return the selection of voice over to the element rotorPropertyValueLabel Use this return to select the desired selection that fills the purpose of its logic
               return UIAccessibilityCustomRotorItemResult.init()
           }
           
           return propertyRotorOption
       }
    
    
    public func textReaderButtonRotor() -> UIAccessibilityCustomRotor {
        
        /// Create a custor Rotor option, it has a name that will be read by voice over, and an action that is a action called when this rotor option is interacted with. The predicate gives you info about the state of this interaction
        let propertyRotorOption = UIAccessibilityCustomRotor.init(name: "글자 읽기") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            /// Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.next
            
            /// You can do any kind of business logic processing here
            if forward {
                self.selected = 2
                self.onTouchButton(self.textReaderButton)
            }

            /// Return the selection of voice over to the element rotorPropertyValueLabel. Use this return to select the desired selection that fills the purpose of its logic
            return UIAccessibilityCustomRotorItemResult.init()
        }
        
        return propertyRotorOption
    }
    
    public func chatButtonRotor() -> UIAccessibilityCustomRotor {
        
        /// Create a custor Rotor option, it has a name that will be read by voice over, and an action that is a action called when this rotor option is interacted with. The predicate gives you info about the state of this interaction
        let propertyRotorOption = UIAccessibilityCustomRotor.init(name: "Chat") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            /// Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.next
            
            /// You can do any kind of business logic processing here
            if forward {
                self.selected = 3
                self.onTouchButton(self.chatButton)
            }

            /// Return the selection of voice over to the element rotorPropertyValueLabel. Use this return to select the desired selection that fills the purpose of its logic
            return UIAccessibilityCustomRotorItemResult.init()
        }
        
        return propertyRotorOption
    }
    
    public func wishlistButtonRotor() -> UIAccessibilityCustomRotor {
        
        /// Create a custor Rotor option, it has a name that will be read by voice over, and an action that is a action called when this rotor option is interacted with. The predicate gives you info about the state of this interaction
        let propertyRotorOption = UIAccessibilityCustomRotor.init(name: "Wishlist") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            /// Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotor.Direction.next
            
            /// You can do any kind of business logic processing here
            if forward {
                self.selected = 4
                self.onTouchButton(self.wishlistButton)
            }

            /// Return the selection of voice over to the element rotorPropertyValueLabel. Use this return to select the desired selection that fills the purpose of its logic
            return UIAccessibilityCustomRotorItemResult.init()
        }
        
        return propertyRotorOption
    }


    @objc func onTouchButton(_ sender: UIButton) {
        self.selected = sender.tag
        if(selected == 1) {
            guard supportLiDAR else {
                showAlert()
                return
            }
            self.navigationButton.setTitleColor(.black, for: .normal)
            self.textReaderButton.setTitleColor(.white, for: .normal)
            self.chatButton.setTitleColor(.white, for: .normal)
            self.wishlistButton.setTitleColor(.white, for: .normal)
 
            self.navigationButton.backgroundColor = .white
            self.textReaderButton.backgroundColor = .black
            self.chatButton.backgroundColor = .black
            self.wishlistButton.backgroundColor = .black

            present(ObjectDetectionViewController(), animated: true)
        } else if (self.selected == 2) {
            guard supportLiDAR else {
                showAlert()
                return
            }
            self.navigationButton.setTitleColor(.white, for: .normal)
            self.textReaderButton.setTitleColor(.black, for: .normal)
            self.chatButton.setTitleColor(.white, for: .normal)
            self.wishlistButton.setTitleColor(.white, for: .normal)
            self.navigationButton.backgroundColor = .black
            self.textReaderButton.backgroundColor = .white
            self.chatButton.backgroundColor = .black
            self.wishlistButton.backgroundColor = .black

            present(TextReaderViewController(), animated: true)
        } else if (self.selected == 3) {
            guard supportLiDAR else {
                showAlert()
                return
            }
            self.navigationButton.setTitleColor(.white, for: .normal)
            self.textReaderButton.setTitleColor(.white, for: .normal)
            self.chatButton.setTitleColor(.black, for: .normal)
            self.wishlistButton.setTitleColor(.white, for: .normal)
            self.navigationButton.backgroundColor = .black
            self.textReaderButton.backgroundColor = .black
            self.chatButton.backgroundColor = .white
            self.wishlistButton.backgroundColor = .black
            present(ChatView(), animated: true)
        } else if (self.selected == 4) {
            guard supportLiDAR else {
                showAlert()
                return
            }
            self.navigationButton.setTitleColor(.white, for: .normal)
            self.textReaderButton.setTitleColor(.white, for: .normal)
            self.chatButton.setTitleColor(.white, for: .normal)
            self.wishlistButton.setTitleColor(.black, for: .normal)
            self.navigationButton.backgroundColor = .black
            self.textReaderButton.backgroundColor = .black
            self.chatButton.backgroundColor = .black
            self.wishlistButton.backgroundColor = .white
            present(WishlistView(), animated: true)
        }
    }

    @objc func openSettingView() {
        let mainVC = SettingViewController()
        present(mainVC, animated: true, completion: nil)
    }

    func showAlert() {
        let alert = UIAlertController(title: translate("알림"), message: translate("이 기기는 LiDAR 센서가 없어, 해당 기능을 사용 할 수 없습니다"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: translate("확인"), style: .default)

        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
}

