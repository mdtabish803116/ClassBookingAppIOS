//
//  viewModal.swift
//  ClassBookingApp
//
//  Created by Tabish on 08/08/23.
//

import Foundation
import UIKit

class ClassBookingViewModal {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var classModals = [ClassBookingItems]()
    var ClassDataArray = [ClassBookingCellData]()
    var cartDataArray = [ClassBookingCellData]()
    
    func deleteItems() async{
        do {
            let modals = try context.fetch(ClassBookingItems.fetchRequest())
            if !modals.isEmpty {
                for data in modals {
                    context.delete(data)
                }
            }
            
        }catch {
            
        }
    }
    
    func createClassItems() async {
        do {
            let modals = try context.fetch(ClassBookingItems.fetchRequest())
            if modals.isEmpty {
            let dataArray = readJSONFile(forName: "BookingData")
            for data in dataArray {
                creatEachItem(id: data["id"] as! Int32, date: data["date"] as! String, time: data["time"] as! String , available: data["available"] as! Int32, booked: data["booked"] as! Bool, added: data["added"] as! Bool)
              }
            }
           
        }catch {
            print(error)
        }
    }
    
    func creatEachItem(id:Int32,date:String,time:String,available:Int32,booked:Bool,added:Bool){
         let newItem = ClassBookingItems(context: context)
        newItem.id = id
        newItem.date = date
        newItem.time = time
        newItem.available = available
        newItem.booked = booked
        newItem.added = added
        
        do {
            try context.save()
        }catch {
            print(error)
        }
    }
    
    func getAllItems() async{
        do {
            classModals = try context.fetch(ClassBookingItems.fetchRequest())
        }catch {
            print(error)
        }
    }
    
    func updateItem(data:ClassBookingItems ,available : Int32 , added: Bool , booked : Bool){
        data.available = available
        data.added = added
        data.booked = booked
        do {
            try context.save()
        }catch {
            print(error)
        }
    }
    
    func saveItem(){
        do {
            try context.save()
        }catch {
            print(error)
        }
    }
    

    func fetchAllItems(completion:@escaping() -> ()){
        Task {
           // await deleteItems()
            await createClassItems()
            await getAllItems()
            createClassDataArray(dataArray: classModals)
            completion()
        }
    }
    
    func readJSONFile(forName name: String) -> [[String:Any]]{
        var data = [[String:Any]]()
       do {
          if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
          let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
             if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any] {
                 data = json["data"] as! [[String:Any]]
             } else {
                print("Given JSON is not a valid dictionary object.")
             }
          }
       } catch {
          print(error)
       }
        
        return data
    }
    
    func generateRandomNumber(_ from: Int , _ to: Int) -> Int{
        let randomNumber = Int.random(in: from...to)
        return randomNumber
    }
    
   
    
}
