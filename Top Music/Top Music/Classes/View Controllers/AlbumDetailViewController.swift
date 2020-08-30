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
    
    private var stackView: UIStackView?
    private let albumLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 18.0), color: .oregonDucksGreen)
    private let artistLabel:UILabel = UILabel.wrapping(font: .customBold(size: 16.0), color: .offWhite)
    private var artwork: UIImageView = UIImageView()
    private let genreLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .gray)
    private let releaseDateLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 14.0), color: .oregonDucksGreen)
    private let copyrightLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 6.0), color: .lightGray)
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
            albumLabel.text = viewModel.albumText
            artistLabel.text = viewModel.artistText
            genreLabel.text = viewModel.genreText
            releaseDateLabel.text = viewModel.releaseDateText
            copyrightLabel.text = viewModel.copyrightText
        } else {
            genreLabel.text = ""
            releaseDateLabel.text = ""
        }
    }
    
    private func configureLayout() {
        let stackVW = UIStackView(arrangedSubviews: [
            albumLabel,
            artistLabel,
            artwork,
            genreLabel,
            releaseDateLabel,
            copyrightLabel
        ])
        stackVW.spacing = 5
        stackVW.alignment = .leading
        stackVW.axis = .vertical
        self.stackView = stackVW

        self.view.addSubviews([stackVW, ctaButton])
        
    }
    
}

extension AlbumDetailViewController: AlbumDetailViewModelDelegate {

    func didGetError(_ error: Error) {
        //
    }

    func detailDidChange(viewModel: AlbumDetailViewModel) {
        updateDisplay()
    }
        
}
