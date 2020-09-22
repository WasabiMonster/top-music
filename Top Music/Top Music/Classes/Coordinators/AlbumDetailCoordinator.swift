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
    
    let transitionClass = StraightLineRetroTransition.self
    private var viewModel: AlbumDetailViewModel
    
    lazy var albumDetailViewController: AlbumDetailViewController = {
        let vc = AlbumDetailViewController(viewModel: self.viewModel)
        vc.albumDetailViewControllerDelegate = self
        return vc
    }()
    
    init(router: RouterProtocol, viewModel: AlbumDetailViewModel) {
        self.viewModel = viewModel
        super.init(router: router)
        router.setRootModule(albumDetailViewController, hideBar: false)
    }
    
    /* init(presenter: UINavigationController, viewModel: AlbumDetailViewModel) {
        self.viewModel = viewModel
        super.init(presenter: presenter)
    } */
        
    /* override func start() {
        let albumDetailViewController = AlbumDetailViewController()
        albumDetailViewController.albumDetailViewControllerDelegate = self
        albumDetailViewController.viewModel = self.viewModel
        presenter.pushViewController(albumDetailViewController, withRetroTransition: transitionClass.init())
    } */
    
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
