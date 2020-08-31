//
//  ImageLoader.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    var imagesData: [AlbumModel]?
    
    public func loadImage(at index: Int) -> ImageLoadOperation? {
        guard let images = imagesData else { return nil }
        if (0..<images.count).contains(index) {
            return ImageLoadOperation(images[index])
        }
        return .none
    }
}

class ImageLoadOperation: Operation {
    var image: UIImage?
    var hasFadedIn: Bool = false
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var model: AlbumModel
    
    init(_ model: AlbumModel) {
        self.model = model
    }
    
    override func main() {
        if isCancelled { return }
        guard let url = model.artworkUrl.toURL else { return }
    
        DispatchQueue.main.async() { [weak self] in
            ImageCache.shared.fetchImageFrom(URL: url) { (image) in
                guard let self = self else { return }
                if self.isCancelled { return }
                if let image = image {
                    self.image = image
                    self.model.imageLoadStatus = .downloaded
                    self.loadingCompleteHandler?(self.image)
                } else {
                    self.model.imageLoadStatus = .failed
                }
            }
        }
    }
}
