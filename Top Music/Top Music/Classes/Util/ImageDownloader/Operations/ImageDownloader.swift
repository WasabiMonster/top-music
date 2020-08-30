//
//  ImageDownloader.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

public class ImageDownloader: Operation {
    internal var model: AlbumModel
    
    init(_ model: AlbumModel) {
        self.model = model
    }
    
    override public func main() {
        guard let imageUrl = URL(string: model.artworkUrl),
            isCancelled == false else { return }
        
        Cache.shared.fetchImageFrom(URL: imageUrl) { (image) in
            if let image = image {
                self.model.image = image
                self.model.imageStatus = .downloaded
            } else {
                self.model.imageStatus = .failed
                self.model.image = UIImage()  // UIImage(named: "Failed") ??
            }
        }
        
    }
    
}
