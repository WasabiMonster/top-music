//
//  AlbumDetailViewController.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/27/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

protocol AlbumDetailViewControllerDelegate: class {
    func albumDetailViewController(_ controller: AlbumDetailViewController, didSelectExternalLink url: String, id: String)
}

final class AlbumDetailViewController: UIViewController {
    
    weak var albumDetailViewControllerDelegate: AlbumDetailViewControllerDelegate?
    
    private var textStackView: UIStackView?
    private let albumLabel:UILabel = UILabel.ducksStyle(font: .customMedium(size: 28.0), color: .oregonDucksYellow)
    private let artistLabel:UILabel = UILabel.wrapping(font: .customBold(size: 22.0), color: .offWhite)
    private var artworkImage: ActivityImageView = ActivityImageView()
    private let genreLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .gray)
    private let releaseDateLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 14.0), color: .lightGray)
    private let copyrightLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 11.0), color: .lightGray)
    private var ctaButton: UIButton = UIButton.callToAction(text: "VIEW IN ITUNES")
    
    let marginPadding: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.middleDark

        configureLayout()
        configureActions()
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
        self.artworkImage.showActivityIndicator()
        if let viewModel = viewModel {
            albumLabel.text = viewModel.albumText
            artistLabel.text = viewModel.artistText
            genreLabel.text = viewModel.genreText
            releaseDateLabel.text = viewModel.releaseDateText
            copyrightLabel.text = viewModel.copyrightText
            
            guard let url = viewModel.artworkUrl.toURL else { return }
    
            DispatchQueue.main.async {
                ImageCache.shared.fetchImageFrom(URL: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.artworkImage.hideActivityIndicator()
                            self.artworkImage.image = image
                            self.artworkImage.fadeInFromOut()
                        } else {
                            // todo: display failed image
                        }
                    }
                }
            }
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
        textStackVW.spacing = 8
        textStackVW.alignment = .leading
        textStackVW.axis = .vertical
        self.textStackView = textStackVW

        self.view.addSubviews([artworkImage, textStackVW, ctaButton])
        
        // Artwork
        artworkImage.backgroundColor = UIColor.oregonDucksGreen
        artworkImage.layer.cornerRadius = 6
        artworkImage.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            artworkImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            artworkImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            artworkImage.widthAnchor.constraint(equalToConstant: 200),
            artworkImage.heightAnchor.constraint(equalTo: artworkImage.widthAnchor)
        ])
        
        // Text Stack
        textStackVW.setCustomSpacing(4, after: self.albumLabel)
        NSLayoutConstraint.activate([
            textStackVW.topAnchor.constraint(equalTo: artworkImage.bottomAnchor, constant: 34.0),
            textStackVW.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: marginPadding),
            textStackVW.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -marginPadding)
        ])
        
        // CTA Button
        NSLayoutConstraint.activate([
            ctaButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: marginPadding),
            ctaButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -marginPadding),
            ctaButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -marginPadding),
            ctaButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func configureActions() {
        ctaButton.addTarget(self, action: #selector(openExternalLink), for: .touchUpInside)
    }
    
    @objc private func openExternalLink() {
        guard let link = viewModel?.iTunesUrl else { return }
        self.albumDetailViewControllerDelegate?.albumDetailViewController(self, didSelectExternalLink: link, id: viewModel?.id ?? "")
    }
    
}

extension AlbumDetailViewController: AlbumDetailViewModelDelegate {

    func didReceiveError(_ error: Error) {
        //
    }

    func detailDidChange(viewModel: AlbumDetailViewModel) {
        updateDisplay()
    }
        
}
