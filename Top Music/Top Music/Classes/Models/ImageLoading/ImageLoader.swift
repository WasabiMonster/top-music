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
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var model: AlbumModel
    
    init(_ model: AlbumModel) {
        self.model = model
    }
    
    override func main() {
        if isCancelled { return }
        guard let url = model.artworkUrl.toURL else { return }
        downloadImageFrom(url) { (image) in
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                if self.isCancelled { return }
                self.image = image
                self.loadingCompleteHandler?(self.image)
            }
        }
    }
}

func downloadImageFrom(_ url: URL, completeHandler: @escaping (UIImage?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let _image = UIImage(data: data)
            else { return }
        completeHandler(_image)
        }.resume()
}
