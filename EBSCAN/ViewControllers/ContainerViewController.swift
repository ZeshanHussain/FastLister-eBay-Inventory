//
//  ViewController.swift
//  EBSCAN
//
//  Created by zeshan hussain on 11/15/23.
//
import CoreAudioTypes

import UIKit

class ContainerViewController: UIViewController {

    
    enum MenuState {
        case opened
        case closed
    }
    
    
    private var menuState : MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    var navVC: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addChildVCs()
        // Do any additional setup after loading the view.
    }
    
    private func addChildVCs() {
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        //home
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }

}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            //open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
          
                }
            }
            
            
            
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        
                        
                        completion?()
                    }
                }
            }
        }
        
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    
    
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        didTapMenuButton()
        print ("select")
        toggleMenu{ [weak self] in
            
            
            switch menuItem {
                
            case .alert:
                break
            case .goods:
                break
            case .staff:
                break
            case .contact:
                let vc = InfoViewController()
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }
        
    }
}
