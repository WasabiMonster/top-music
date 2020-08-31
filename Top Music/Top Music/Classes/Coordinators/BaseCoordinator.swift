//
//  BaseCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {
    var presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
}

extension BaseCoordinator: Equatable {
    
    static func == (lhs: BaseCoordinator, rhs: BaseCoordinator) -> Bool {
        return lhs === rhs
    }
    
}
