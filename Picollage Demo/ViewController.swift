//
//  ViewController.swift
//  Picollage Demo
//
//  Created by Samuel on 2018/10/6.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var activityIndicator: UIActivityIndicatorView!
    var collectionView: UICollectionView!
    
    private lazy var demoTextContainer: UIView = {
        let container = UIView()
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 5)
        container.layer.shadowRadius = 6
        container.layer.shadowOpacity = 0.1
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var demoTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Input Demo Content"
        textField.isHidden = true
        textField.alpha = 0
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 4.0
        return textField
    }()
    
    var dataStore: FontDataStore = FontDataStore()
    var manager: ServiceManager = ServiceManager(urlSession: URLSession.shared)
    var fetchTimer: Timer!
    var currentSelectedFontModel: FontModel? {
        didSet {
            DispatchQueue.main.async {
                self.demoTextField.font = self.currentSelectedFontModel?.customFont?.withSize(24) ??
                    UIFont.systemFont(ofSize: UIConstant.fontSize).withSize(24)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        manager.fetchFontInformation { [weak self] (success, result) -> (Void) in
            DispatchQueue.main.async {
                if success, let result = result {
                    self?.dataStore.dataSources = Array(result[0..<APIConstant.loadedFontNumber])
                }
            }
        }
        
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false
            , block: { (timer) in
                self.showContents()
        })
    }
    
    
    func commonInit() {
        
        dataStore.delegate = self
        
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        searchBar.layer.cornerRadius = 2
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIConstant.searchBGColor.cgColor
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.barTintColor = UIConstant.searchBGColor
        searchBar.tintColor = UIConstant.defaultTextColor
        searchBar.placeholder = "搜尋字體..."
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.isUserInteractionEnabled = false
        
        view.addSubview(demoTextContainer)
        NSLayoutConstraint.activate([
            demoTextContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 32),
            demoTextContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            demoTextContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            demoTextContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            demoTextContainer.heightAnchor.constraint(equalToConstant: 48)
            ])
        
        demoTextContainer.addSubview(demoTextField)
        NSLayoutConstraint.activate([
            demoTextField.topAnchor.constraint(equalTo: demoTextContainer.topAnchor),
            demoTextField.bottomAnchor.constraint(equalTo: demoTextContainer.bottomAnchor),
            demoTextField.leftAnchor.constraint(equalTo: demoTextContainer.leftAnchor, constant: 0),
            demoTextField.rightAnchor.constraint(equalTo: demoTextContainer.rightAnchor, constant: 0),
            ])
        
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 50) / 2, height: 50)
        collectionLayout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        collectionLayout.minimumLineSpacing = 15
        
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: collectionLayout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = dataStore
        collectionView.register(FontDisplayCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: demoTextContainer.bottomAnchor, constant: 24).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearTempContents),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
    }
    
    @objc func clearTempContents() {
        dataStore.clearTempFiles()
    }
    
    func showContents() {
        self.collectionView.isHidden = false
        self.demoTextField.isHidden = false
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.activityIndicator.alpha = 0
                        self.collectionView.alpha = 1.0
                        self.demoTextField.alpha = 0.6
        }, completion: { (success) in
            self.activityIndicator.isHidden = true
            self.searchBar.isUserInteractionEnabled = true
        })
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataStore.searchContent = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataStore.searchContent = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIConstant.selectedGreenColor.cgColor
        UIView.animate(withDuration: 0.2) {
            self.demoTextField.alpha = 1.0
            self.demoTextContainer.transform = CGAffineTransform(translationX: 0, y: -16)
            self.demoTextContainer.layer.shadowOffset = CGSize(width: 0, height: 6)
            self.demoTextContainer.layer.shadowRadius = 7
            self.demoTextContainer.layer.shadowOpacity = 0.05
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIConstant.searchBorderColor.cgColor
        UIView.animate(withDuration: 0.2) {
            self.demoTextField.alpha = 0.6
            self.demoTextContainer.transform = CGAffineTransform.identity
            self.demoTextContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
            self.demoTextContainer.layer.shadowRadius = 6
            self.demoTextContainer.layer.shadowOpacity = 0.1
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedFontModel = self.dataStore.filteredDataSources[indexPath.row]
    }
}

extension ViewController: FontDataStoreDelegate {
    func fontDataStoreDidUpdated(_ dataStore: FontDataStore?, _ indexPath: IndexPath?) {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.collectionView.reloadData()
            }
            
            if let dataStore = dataStore,
                dataStore.filteredDataSources.count == APIConstant.loadedFontNumber {
                
                if self.fetchTimer.isValid {
                    self.fetchTimer.invalidate()
                }
                
                self.showContents()
            }
        }
    }
}
