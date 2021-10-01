//
//  ImageDataService.swift
//  Weather v1
//
//  Created by Максим on 25/09/2021.
//

import UIKit

protocol ImageDataService {
    func downloadImage(condition: String, completion: @escaping (UIImage?) -> Void)
}

class ImageDataServiceImpl: ImageDataService {
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(condition: String, completion: @escaping (UIImage?) -> Void) {
        
        let second = setCondition(condition: condition)
        let urlString = "https://gdurl.com\(second)"
        guard let url = URL(string: urlString) else { return }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                guard error == nil,
                      data != nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let `self` = self else {
                    return
                }
                
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
    
    private func setCondition(condition: String) -> String {
        switch condition {
        case "clear":
            return "/ie1I"
            
        case "partly-cloudy":
            return "/ScqW"
            
        case "cloudy":
            return "/93ON"
            
        case "overcast":
            return "/cA_R"
            
        case "drizzle":
            return "/obm1"
            
        case "light-rain":
            return "/IT0v"
            
        case "rain":
            return "/h5jc"
            
        case "moderate-rain":
            return "/DgAF"
            
        case "heavy-rain":
            return "/txAW"
            
        case "continuous-heavy-rain":
            return "/rksi"
            
        case "showers":
            return "/znVv"
            
        case "wet-snow":
            return "/Zl8H"
            
        case "light-snow":
            return "/i779"
            
        case "snow":
            return "/caoj"
            
        case "snow-showers":
            return "/lXet"
            
        case "hail":
            return "/Wgj8"
            
        case "thunderstorm":
            return "/YgqS"
            
        case "thunderstorm-with-rain":
            return "/JcJJ"
            
        case "thunderstorm-with-hail":
            return "/Qrcp"
            
        default:
            return "/XWAb"
        }
    }
    
}

