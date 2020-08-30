//
//  AlbumDetailViewController.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/27/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

protocol AlbumDetailViewControllerDelegate: class {
    func albumDetailViewController(_ controller: AlbumDetailViewController, didSelectExternalLink url: String)
}

final class AlbumDetailViewController: UIViewController {
    
    weak var albumDetailViewControllerDelegate: AlbumDetailViewControllerDelegate?
    
    private let stackView = UIStackView()
    private let genreLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .offWhite)
    private let releaseDateLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 14.0), color: .oregonDucksGreen)
    private var artwork: UIImageView = UIImageView()
    private var ctaButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.almostBlack

        configureLayout()
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
            releaseDateLabel.text = viewModel.copyrightText
        } else {
            genreLabel.text = ""
            releaseDateLabel.text = ""
        }
    }
    
    private func configureLayout() {
        self.view.addSubviews([stackView, genreLabel, releaseDateLabel, artwork, ctaButton])
        
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
