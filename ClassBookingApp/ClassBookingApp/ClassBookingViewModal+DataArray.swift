//
//  ClassBookingViewModal+DataArray.swift
//  ClassBookingApp
//
//  Created by Tabish on 08/08/23.
//

import Foundation

extension ClassBookingViewModal {
    
    func createClassDataArray(dataArray:[ClassBookingItems]){
        ClassDataArray.removeAll()
        cartDataArray.removeAll()
        for data in dataArray {
            let dataDictionary = [
                "id": data.id,
                "date": data.date ?? "",
                "time": data.time ?? "" ,
                "available": data.available,
                "booked":data.booked,
                "added": data.added
            ] as [String : Any]
            if data.added {
                appendCartTableCellData(dictionary: dataDictionary)
            }
            appendTableCellData(dictionary: dataDictionary)
        }
    }
    
    func appendTableCellData(dictionary:[String:Any]){
        let data = ClassBookingCellData(
            cellType:.tableCell,
            data:dictionary
         )
        ClassDataArray.append(data)
    }
    
    func appendCartTableCellData(dictionary:[String:Any]){
        let data = ClassBookingCellData(
            cellType:.cartTableCell,
            data:dictionary
         )
        cartDataArray.append(data)
    }
}

struct ClassBookingCellData {
    var cellType = ClassBookingCellTypes.none
    var data = Dictionary<String,Any>()
}

enum ClassBookingCellTypes{
    case tableCell
    case cartTableCell
    case none
}

