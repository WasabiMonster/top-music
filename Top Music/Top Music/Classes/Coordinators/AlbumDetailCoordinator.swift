//
//  AlbumDetailCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailCoordinator: BaseCoordinator {
    
    private var viewModel: AlbumDetailViewModel
    
    init(presenter: UINavigationController, viewModel: AlbumDetailViewModel) {
        self.viewModel = viewModel
        super.init(presenter: presenter)
    }
        
    override func start() {
        let albumDetailViewController = AlbumDetailViewController()
        albumDetailViewController.albumDetailViewControllerDelegate = self
        albumDetailViewController.viewModel = self.viewModel
        presenter.pushViewController(albumDetailViewController, animated: true)
    }
    
}

extension AlbumDetailCoordinator: AlbumDetailViewControllerDelegate {

    func albumDetailViewController(_ controller: AlbumDetailViewController, didSelectExternalLink url: String) {
        if let url = URL(string: "itms://apple.com/app/id839686104")  {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                print("*082920* TODO: goto external link: \(url)")
            } else {
                print("*083020* \(type(of: self)), \(#function) || nope")
                // UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            // itms-apps://itunes.apple.com/app/id  1512216102
        }
    }
    
}
