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
    
    private var textStackView: UIStackView?
    private let albumLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 28.0), color: .oregonDucksGreen)
    private let artistLabel:UILabel = UILabel.wrapping(font: .customBold(size: 22.0), color: .offWhite)
    private var artworkImage: UIImageView = UIImageView()
    private let genreLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .gray)
    private let releaseDateLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 14.0), color: .lightGray)
    private let copyrightLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 12.0), color: .lightGray)
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
        let textStackVW = UIStackView(arrangedSubviews: [
            albumLabel,
            artistLabel,
            genreLabel,
            releaseDateLabel,
            copyrightLabel
        ])
        textStackVW.spacing = 5
        textStackVW.alignment = .leading
        textStackVW.axis = .vertical
        self.textStackView = textStackVW

        self.view.addSubviews([artworkImage, textStackVW, ctaButton])
        
        // Artwork
        artworkImage.backgroundColor = UIColor.nikeFootball
        artworkImage.layer.cornerRadius = 6
        artworkImage.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            artworkImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            artworkImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            artworkImage.widthAnchor.constraint(equalToConstant: 250),
            artworkImage.heightAnchor.constraint(equalTo: artworkImage.widthAnchor)
        ])
        
        // Text Stack
        NSLayoutConstraint.activate([
            textStackVW.topAnchor.constraint(equalTo: artworkImage.bottomAnchor, constant: 40),
            textStackVW.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        
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
