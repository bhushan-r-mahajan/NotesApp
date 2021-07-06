//
//  ViewController.swift
//  Notes
//
//  Created by Gadgetzone on 05/07/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- Properties
    
    var menuController: MenuController!
    var centreController: UIViewController!
    var isExpanded = false
    
    // MARK:- Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
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
            case .Profile: print("Show Profile")
            case .Reminders: print("Show Reminders")
            case .Logout: print("Perform Logout")
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

extension ViewController: HomeControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        menuActions(shouldExpand: isExpanded, menuOption: menuOption)
    }
}

