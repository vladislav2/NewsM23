//
//  Extensions.swift
//  TXiBPcod
//
//  Created by user on 06.01.2021.
//

import Foundation
import UIKit

//extension UIImageView {
//
//    let imageCache = NSCache<NSString, UIImage>()
//
//        func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
//
//        self.image = nil
//        //If imageurl's imagename has space then this line going to work for this
//        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
//            self.image = cachedImage
//            return
//        }
//
//        if let url = URL(string: imageServerUrl) {
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//
//                //print("RESPONSE FROM API: \(response)")
//                if error != nil {
//                    print("ERROR LOADING IMAGES FROM URL: \(error)")
//                    DispatchQueue.main.async {
//                        self.image = placeHolder
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    if let data = data {
//                        if let downloadedImage = UIImage(data: data) {
//                            imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
//                            self.image = downloadedImage
//                        }
//                    }
//                }
//            }).resume()
//        }
//    }
//}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
