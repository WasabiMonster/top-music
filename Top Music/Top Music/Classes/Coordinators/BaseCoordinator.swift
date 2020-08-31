//
//  BaseCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    
    func start()
}

class BaseCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    var parentCoordinator: Coordinator?
    
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
