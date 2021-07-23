//
//  ViewController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit
import Firebase

class ContainerController: UIViewController {

    // MARK:- Properties
    
    var menuController: MenuController!
    var centreController: UIViewController!
    var isExpanded = false
    
    // MARK:- Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        athenticateUserLogin()
        //configureHomeController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }

    // MARK:- Handlers
    
    func configureHomeController() {
        let homeController = HomeController()
        homeController.delegate = self
        centreController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centreController.view)
        addChild(centreController)
        centreController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func menuActions(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.centreController.view.frame.origin.x = self.centreController.view.frame.width - 80
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.centreController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
            case .Profile:
                print("Show Profile")
                let profile = ProfileController()
                let nav = UINavigationController(rootViewController: profile)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
                
            case .Reminders:
                print("Show Reminders")
                let reminder = RemainderController()
                let nav = UINavigationController(rootViewController: reminder)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
                
            case .Logout:
                print("logged out")
                do {
                    try Auth.auth().signOut()
                    let login = LoginController()
                    let nav = UINavigationController(rootViewController: login)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                } catch {
                    print("Error loggin out !!")
                    present(Checker.showAlert(title: "Log Out Failed", message: "Something went wrong at Loggin out !"), animated: true, completion: nil)
                }
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func athenticateUserLogin() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let login = LoginController()
                //login.delegate = self
                let nav = UINavigationController(rootViewController: login)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureHomeController()
        }
    }
}

extension ContainerController: HomeControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        print("Menu toggled")
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        menuActions(shouldExpand: isExpanded, menuOption: menuOption)
    }
}

//extension ContainerController: authenticationDelegate {
//    func showHomeController() {
//        configureHomeController()
//    }
//}
