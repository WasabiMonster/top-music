//
//  AlbumCell.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

class AlbumCell: UITableViewCell {
    public static let reusableId: String = "AlbumCell"
    private let artistLabel:UILabel = UILabel.wrapping(font: .customBold(size: 14.0), color: .offWhite)
    private let albumLabel:UILabel = UILabel.wrapping(font: .customMedium(size: 14.0), color: .oregonDucksGreen)
    private var artwork: UIImageView = UIImageView()
        
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
        self.addSubviews([artistLabel, albumLabel, artwork])
        self.backgroundColor = UIColor.darkGray
        
        // Artist Label
        NSLayoutConstraint.activate([
            self.artistLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.artistLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
            // self.artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10),
            // self.artistLabel.widthAnchor.constraint(equalTo: self.artworkView.heightAnchor)
        ])
        
        // print("*082820* \(type(of: self)), \(#function) |> \(artistLabel) \(self.contentView)")
        
    }
    
    func populate(artist: String,
                  album: String,
                  artwork: UIImage?) {
        self.artistLabel.text = artist
        self.albumLabel.text = album
        self.artwork.image = artwork
    }
    
    override func prepareForReuse() {
        artistLabel.text = ""
        albumLabel.text = ""
        imageView?.image = nil
        // artwork = nil
        super.prepareForReuse()
    }
    
}
