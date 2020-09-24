//
//  AlbumDetailCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailCoordinator: Coordinator<DeepLink> {
    
    let transitionClass = StraightLineWaveTransition.self
    private var viewModel: AlbumDetailViewModel
    
    lazy var albumDetailViewController: AlbumDetailViewController = {
        let vc = AlbumDetailViewController(viewModel: self.viewModel)
        vc.albumDetailViewControllerDelegate = self
        return vc
    }()
    
    init(router: RouterProtocol, viewModel: AlbumDetailViewModel) {
        self.viewModel = viewModel
        super.init(router: router)
        // router.setRootModule(albumDetailViewController, hideBar: false)
    }
    
    /* override func start() {
        let albumDetailViewController = AlbumDetailViewController()
        albumDetailViewController.albumDetailViewControllerDelegate = self
        albumDetailViewController.viewModel = self.viewModel
        presenter.pushViewController(albumDetailViewController, withWaveTransition: transitionClass.init())
    } */
    
    // We must override toPresentable() so it doesn't
    // default to the router's navigationController
    override func toPresentable() -> UIViewController {
        return albumDetailViewController
    }
    
}

extension AlbumDetailCoordinator: AlbumDetailViewControllerDelegate {

    func albumDetailViewController(_ controller: AlbumDetailViewController, didSelectExternalLink url: String, id: String) {
        if let appUrl = URL(string: "itms://music.apple.com/us/album/id/\(id)")  {
            if UIApplication.shared.canOpenURL(appUrl) {
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            } else {
                let webUrlString = "https://music.apple.com/us/album/id/\(id)"
                print("Cannot open Music app. Attempting \(webUrlString) in browser.")
                if let webUrl = URL(string: webUrlString) {
                    UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
}
