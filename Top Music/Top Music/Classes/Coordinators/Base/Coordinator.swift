//
//  Coordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 9/19/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

public protocol BaseCoordinatorProtocol: class {
    associatedtype DeepLinkProtocol
    func start()
    func start(with link: DeepLinkProtocol?)
}

public protocol PresentableCoordinatorProtocol: BaseCoordinatorProtocol, Presentable {}

open class PresentableCoordinator<DeepLinkProtocol>: NSObject, PresentableCoordinatorProtocol {
    
    public override init() {
        super.init()
    }
    
    open func start() { start(with: nil) }
    open func start(with link: DeepLinkProtocol?) {}

    open func toPresentable() -> UIViewController {
        fatalError("Must override toPresentable()")
    }
}


public protocol CoordinatorType: PresentableCoordinatorProtocol {
    var router: RouterProtocol { get }
}


open class Coordinator<DeepLinkProtocol>: PresentableCoordinator<DeepLinkProtocol>, CoordinatorType  {
    
    public var childCoordinators: [Coordinator<DeepLinkProtocol>] = []
    
    open var router: RouterProtocol
    
    public init(router: RouterProtocol) {
        self.router = router
        super.init()
    }
    
    public func addChild(_ coordinator: Coordinator<DeepLinkProtocol>) {
        childCoordinators.append(coordinator)
    }
    
    public func removeChild(_ coordinator: Coordinator<DeepLinkProtocol>?) {
        
        if let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        }
    }
    
    open override func toPresentable() -> UIViewController {
        return router.toPresentable()
    }
}
