//
//  ServiceManager.swift
//  Picollage Demo
//
//  Created by Samuel on 2018/10/6.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {

    let urlSession: URLSession!
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
        super.init()
    }
    
    func fetchFontInformation(_ completion: @escaping (Bool, [FontModel]?) -> (Void)) {
        
        if let url = URL(string: APIConstant.BaseURL + "?key=" + APIConstant.APIKey) {
            let fetchRequest = URLRequest(url: url)
            let task = urlSession.dataTask(with: fetchRequest) { (data, response, error) in
                
                if error != nil {
                    completion(false, nil)
                } else if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let items = json!["items"] as? [[String: Any]] {
                    
                    var fontFiles: [FontModel] = []
                    for case let item in items {
                        if let fontFile = try? JSONDecoder().decode(FontModel.self,
                                                                    from: JSONSerialization.data(withJSONObject: item,
                                                                                                 options: .prettyPrinted)) {
                            fontFiles.append(fontFile)
                        }
                    }
                    completion(true, fontFiles)
                } else {
                    completion(false, nil)
                }
                
            }
            task.resume()
        }
    }
}


