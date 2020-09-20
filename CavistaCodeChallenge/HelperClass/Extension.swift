//
//  Extension.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/19/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//


import UIKit
import RxDataSources

//MARK:- Reusable Protocol
protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK:- TableView Extension
extension UITableView {
    
    func dequeueReusableCell<T:UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: ReusableView {}

//MARK :- String Extension
extension String {
    var toUrl: URL? {
        let url = URL(string: self)
        return url
    }
    
    //Empty String
    static var emptyString: String {
        return ""
    }
}

//MARK :- Section Document data
struct SectionOfDocumentData<T> {
    var header: String
    var items: [T]
}

extension SectionOfDocumentData: SectionModelType {
    init(original: SectionOfDocumentData, items: [T]) {
        self = original
        self.items = items
    }
}

//MARK:- Sequence Extension
extension Sequence {
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = dict[key]?.append(element) { dict[key] = [element] }
        }
        return dict
    }
}

//MARK:- ImageView Extension
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func downloadImage(from imgURL: String) -> URLSessionDataTask? {
        guard let url = URL(string: imgURL) else { return nil }
        image = nil
        
        // check if the image is already in the cache
        if let imageToCache = imageCache.object(forKey: imgURL as NSString) {
            self.image = imageToCache
            return nil
        }
        
        // download the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            
            DispatchQueue.main.async {
                // create UIImage
                if let data = data {
                    if let imageToCache = UIImage(data: data) {
                        // add image to cache
                        imageCache.setObject(imageToCache, forKey: imgURL as NSString)
                        self.image = imageToCache
                    }
                }
            }
        }
        task.resume()
        return task
    }
}

extension UINavigationController {
    func navigateToDetailView(listBO: ListJsonBO) {
        let detailViewController = DetailViewController()
        detailViewController.listDetailBO = listBO
        self.pushViewController(detailViewController, animated: false)
    }
}

