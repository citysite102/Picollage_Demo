//
//  FontDataStore.swift
//  Picollage Demo
//
//  Created by Samuel on 2018/10/6.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit
import CoreText

protocol FontDataStoreDelegate: NSObjectProtocol {
    func fontDataStoreDidUpdated(_ dataStore: FontDataStore?, _ indexPath: IndexPath?)
}

class FontDataStore: NSObject, UICollectionViewDataSource {
    
    weak var delegate: FontDataStoreDelegate?
    var searchContent: String = "" {
        didSet {
            self.delegate?.fontDataStoreDidUpdated(self, nil)
        }
    }
    var selectedIndexPath: IndexPath?
    
    
    /* Data Source */
    var dataSources: [FontModel] = [] {
        didSet {
            loadedDataSources.removeAll()
            for (index, model) in dataSources.enumerated() {
                self.loadFontResource(model, index)
            }
        }
    }
    public var filteredDataSources: [FontModel] {
        return searchDataSources != nil ? searchDataSources! : loadedDataSources
    }
    private var loadedDataSources: [FontModel] = []
    private var searchDataSources: [FontModel]? {
        if searchContent != "" {
            return loadedDataSources.filter { (model) -> Bool in
                return model.family.localizedCaseInsensitiveContains(searchContent)
            }
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FontDisplayCell
        let dataSource =  filteredDataSources[indexPath.row]
        
        cell.fontDisplayLabel.text = "--\(indexPath.row)"
        if let font = dataSource.customFont {
            cell.fontDisplayLabel.font = font
        }
        
        cell.fontDisplayLabel.text = "\(indexPath.row).\(dataSource.family)"
        cell.fontDisplayLabel.textColor = dataSource.customColor
        cell.dataModel = dataSource
        
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
    
    func loadFontResource(_ model: FontModel, _ index: Int) {
        if let url = URL(string: model.files.regular.replacingOccurrences(of: "http", with: "https")) {
    
            let request = URLRequest(url: url)
            let configuration = URLSessionConfiguration.default
            
            configuration.timeoutIntervalForRequest = .infinity
            let urlSession = URLSession(configuration: configuration)
            let downloadTask = urlSession.downloadTask(with: request) { [weak self] (url, response, error) in
                guard error == nil else {return}
                if var dataSource = self?.dataSources[index],
                    let url = url,
                    let sourceData = try? Data(contentsOf: url) {
                    if let customFont = self?.loadFont(sourceData) {
                        DispatchQueue.main.async {
                            dataSource.customFont = customFont
                            dataSource.customColor = UIConstant.textColors.randomElement() ?? UIConstant.defaultTextColor
                            self?.loadedDataSources.append(dataSource)
                            self?.delegate?.fontDataStoreDidUpdated(self, nil)
                        }
                    }
                }
            }
            downloadTask.resume()
        }
    }
    
    func loadFont(_ fontData: Data) -> UIFont? {
        var error: Unmanaged<CFError>?
        if let provider = CGDataProvider(data: fontData as CFData) {
            if let font = CGFont(provider) {
                if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                    CTFontManagerUnregisterGraphicsFont(font, &error)
                    print(error.debugDescription)
                    return nil
                } else if let customFont = UIFont(name: font.fullName! as String, size: UIConstant.fontSize) {
                    return customFont
                } else {
                    let fontName = font.fullName! as NSString
                    var fontComponents = fontName.components(separatedBy: .whitespaces)
                    if fontComponents.count >= 2 {
                        fontComponents.removeLast()
                        let updatedFontName = fontComponents.joined(separator: " ")
                        if let customFont = UIFont(name: String(updatedFontName), size: UIConstant.fontSize) {
                            return customFont
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func releaseFont(_ fontData: Data) {
        var error: Unmanaged<CFError>?
        if let provider = CGDataProvider(data: fontData as CFData) {
            if let font = CGFont(provider) {
                CTFontManagerUnregisterGraphicsFont(font, &error)
            }
        }
    }
}
