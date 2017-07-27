//
//  ContainerViewController.swift
//  Tippy
//
//  Created by Wynne M Lo on 22/7/2017.
//  Copyright © 2017 Wynne Lo. All rights reserved.
//

import UIKit

// Container to contain slide out panel and center container
// see: https://www.raywenderlich.com/78568/create-slide-out-navigation-panel-swift

enum SlideOutState {
    case Collapsed
    case RightPanelExpanded
}

class ContainerViewController: UIViewController {
    
    let centerPanelExpandedOffset: CGFloat = 100
    var centerNavigationController: UINavigationController!
    var centerViewController: TipViewController!
    var currentState: SlideOutState = .Collapsed {
        didSet {
            let shouldShowShadow = currentState != .Collapsed
            showShadowForCenterViewController(shouldShowShadow: shouldShowShadow)
        }
    }
    var rightViewController: SettingsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self as TipViewControllerDelegate
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
        
    }
}

extension ContainerViewController: TipViewControllerDelegate {
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = UIStoryboard.rightViewController()
            
            addChildSidePanelController(sidePanelController: rightViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SettingsViewController) {
        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: -centerNavigationController.view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .Collapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { 
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func rightViewController() -> SettingsViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
    }
    
    class func centerViewController() -> TipViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "TipViewController") as? TipViewController
    }
    
}
