//
//  AlbumCell.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

class AlbumCell: UITableViewCell {
    public static let reusableId: String = "AlbumCell"
    private let albumLabel:UILabel = UILabel.ducksStyle(font: .customMedium(size: 20.0), color: .oregonDucksYellow, wraps: false)
    private let artistLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .offWhite)
    private var artworkImage: UIImageView = UIImageView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addActivityIndicator() {
        if accessoryView == nil {
            accessoryView = UIActivityIndicatorView(style: .medium)
        }
    }
    
    func startActivityIndicator() {
        guard let indicator = accessoryView as? UIActivityIndicatorView else { return }
        indicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        guard let indicator = accessoryView as? UIActivityIndicatorView else { return }
        indicator.stopAnimating()
    }

    private func configureLayout() {
        self.addSubviews([artistLabel, albumLabel, artworkImage])
        self.backgroundColor = UIColor.almostBlack
        
        // Artwork Image
        artworkImage.backgroundColor = UIColor.oregonDucksGreen
        artworkImage.layer.cornerRadius = 2
        NSLayoutConstraint.activate([
            artworkImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            artworkImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            artworkImage.widthAnchor.constraint(equalToConstant: 42),
            artworkImage.heightAnchor.constraint(equalTo: artworkImage.widthAnchor)
        ])
        
        // Album Label
        NSLayoutConstraint.activate([
            albumLabel.leadingAnchor.constraint(equalTo: artworkImage.trailingAnchor, constant: 14),
            albumLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            albumLabel.topAnchor.constraint(equalTo: artworkImage.topAnchor)
        ])
        
        // Artist Label
        NSLayoutConstraint.activate([
            artistLabel.leadingAnchor.constraint(equalTo: albumLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            artistLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 2)
        ])
                
    }
    
    func populate(artist: String,
                  album: String,
                  artwork: UIImage?) {
        self.artistLabel.text = artist
        self.albumLabel.text = album
        self.artworkImage.image = artwork
    }
    
    func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async { [unowned self] in
            self.displayImage(image)
        }
    }
    
    private func displayImage(_ image: UIImage?) {
        if let image = image {
            artworkImage.image = image
            stopActivityIndicator()
        } else {
            startActivityIndicator()
            artworkImage.image = .none
        }
    }
    
    override func prepareForReuse() {
        artistLabel.text = ""
        albumLabel.text = ""
        // imageView?.image = nil
        // artwork = nil
        // artworkImage.cancelImageLoad()
        super.prepareForReuse()
    }
    
}
