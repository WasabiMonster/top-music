//
//  AlbumDetailViewController.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/27/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

protocol AlbumDetailViewControllerDelegate: class {
    // didSelect external link...
    // func albumdetailViewController(_ controller: AlbumDetailViewController, didSelectAlbumAt index: Int)
    // didReceiveError
}

final class AlbumDetailViewController: UIViewController {
    
    private let genreLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .offWhite)
    private let releaseDateLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 14.0), color: .oregonDucksGreen)
    private var artwork: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
    }
    
    var viewModel: AlbumDetailViewModel? {
        willSet {
            // viewModel?.viewDelegate = nil
        }
        didSet {
            // viewModel?.viewDelegate = self
            updateDisplay()
        }
    }
    
    fileprivate func updateDisplay() {
        if let viewModel = viewModel {
            genreLabel.text = "temp genre"
            releaseDateLabel.text = "01/01/1976"
        } else {
            genreLabel.text = ""
            releaseDateLabel.text = ""
        }
    }
    
}

// stack view
