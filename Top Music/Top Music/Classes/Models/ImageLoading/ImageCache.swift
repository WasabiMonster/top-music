//
//  Cache.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/30/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

open class ImageCache: NSCache<NSURL, UIImage> {
    static var shared = ImageCache()
    
    func fetchImageFrom(URL: URL, completion: @escaping (UIImage?) -> Void) {
        guard let imageNSURL = NSURL.init(string: URL.absoluteString) else { return }
        if let image = self.object(forKey: imageNSURL) {
            completion(image)
        } else {
            downloadImage(URL: URL) { (newImage) in
                if let newImage = newImage,
                    let data = newImage.jpegData(compressionQuality: 1.0),
                    let compressedImage = UIImage(data: data) {
                    self.setObject(compressedImage, forKey: imageNSURL)
                    completion(compressedImage)
                } else { completion(nil) }
            }
        }
    }
    
    func downloadImage(URL: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: URL) { (data, _, _) in
            guard let data = data, let image = UIImage(data: data) else { completion(nil); return }
            completion(image)
        }.resume()
    }
    
}
