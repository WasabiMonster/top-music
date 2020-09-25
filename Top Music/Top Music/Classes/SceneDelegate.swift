//
//  SceneDelegate.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    lazy var appNavigationController: UINavigationController = UINavigationController()
    lazy var appRouter: RouterProtocol = Router(navigationController: self.appNavigationController)
    lazy var appCoordinator: AppCoordinator = AppCoordinator(router: self.appRouter)

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        self.launchCoordinator()
    }

    func launchCoordinator() {
        window?.rootViewController = appCoordinator.toPresentable()
        window?.backgroundColor = .systemBlue
        window?.makeKeyAndVisible()
        
        // or get notification from launch options and convert it to a deep link
        appCoordinator.start()
        
        /* DispatchQueue.main.async { [weak self] in
            appCoordinator = AppCoordinator(window: self?.window ?? UIWindow())
            appCoordinator.start()
            self?.appCoordinator = appCoordinator
        } */
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}

