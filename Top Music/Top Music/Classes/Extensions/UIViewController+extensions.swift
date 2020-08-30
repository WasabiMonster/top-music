//
//  UIViewController+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // An alert using it's description as the message with an "OK" action.
    func presentErrorAlert(_ error: Error, onConfirmation: (()->Void)? = nil) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onConfirmation?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}

// For adding and removing child view controllers.
@nonobjc extension UIViewController {
    func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeChild() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
