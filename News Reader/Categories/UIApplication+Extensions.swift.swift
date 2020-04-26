//
//  UIApplication+Extensions.swift.swift
//  News Reader
//
//  Created by sathiyamoorthy N on 26/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    @objc class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    @objc class func topViewControllerObjcC(controller: UIViewController?) -> UIViewController? {
        var topController = controller
        if controller == nil {
            topController = UIApplication.shared.keyWindow?.rootViewController
        }
        if let navigationController = topController as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = topController as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = topController?.presentedViewController {
            return topViewController(controller: presented)
        }
        return topController
    }
}
