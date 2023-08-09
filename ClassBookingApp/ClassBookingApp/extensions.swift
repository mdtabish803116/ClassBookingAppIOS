//
//  extensions.swift
//  ClassBookingApp
//
//  Created by Tabish on 08/08/23.
//

import Foundation
import UIKit

extension String {
   
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}

extension UITableView {
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}

class AppUtility {
    class func saveArrayDictionaryToDefaults(arrayDictionary:[[String:Any]], key:String){
        UserDefaults.standard.set(arrayDictionary, forKey: key)
    }
    
    class func getArrayDictionaryFromDefaults(key:String) -> [[String:Any]] {
        var arrayDictionary = [[String:Any]]()
        if let loadedCart = UserDefaults.standard.array(forKey: key) as? [[String: Any]] {
            arrayDictionary = loadedCart
        }
        
        return arrayDictionary
    }
}



