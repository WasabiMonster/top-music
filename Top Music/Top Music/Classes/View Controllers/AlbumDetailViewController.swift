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
    
    weak var albumDetailViewControllerDelegate: AlbumDetailViewControllerDelegate?
    
    private let genreLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .offWhite)
    private let releaseDateLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 14.0), color: .oregonDucksGreen)
    private var artwork: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // stackview
        updateDisplay()
    }
    
    var viewModel: AlbumDetailViewModel? {
        willSet {
            viewModel?.delegate = nil
        }
        didSet {
            viewModel?.delegate = self
            updateDisplay()
        }
    }
    
    fileprivate func updateDisplay() {
        if let viewModel = viewModel {
            genreLabel.text = viewModel.genreText
            releaseDateLabel.text = "01/01/1976"
        } else {
            genreLabel.text = ""
            releaseDateLabel.text = ""
        }
    }
    
}

extension AlbumDetailViewController: AlbumDetailViewModelDelegate {

    func didGetError(_ error: Error) {
        //
    }

    func detailDidChange(viewModel: AlbumDetailViewModel) {
        //
    }
        
}
