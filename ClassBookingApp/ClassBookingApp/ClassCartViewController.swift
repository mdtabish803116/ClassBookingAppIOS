//
//  ClassCartViewController.swift
//  ClassBookingApp
//
//  Created by Tabish on 09/08/23.
//

import UIKit

class ClassCartViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!
    var cartArrayData = [[String:Any]]()
    let viewModal = ClassBookingViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        registerTablevViewCell()
        loadData()
    }
    
    func registerTablevViewCell(){
        tableView.registerCellNib(ClassBookingTableCell.self)
    }
    
    func loadData(){
        fetchCartData {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func fetchCartData(completion : @escaping()->()){
      //  UserDefaults.standard.removeObject(forKey: "ClassBookingCartData")
       
         cartArrayData = AppUtility.getArrayDictionaryFromDefaults(key:"ClassBookingCartData")
         completion()
    }
    
}

extension ClassCartViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataArray = cartArrayData
        guard dataArray.count > indexPath.row else { return UITableViewCell() }
        
        let data = dataArray[indexPath.row]
            return getClassBookingTableCell(for: indexPath , data : data)
       
    }
    
    private func getClassBookingTableCell(for indexPath:IndexPath,data:[String:Any]) -> UITableViewCell{
        let cell: ClassBookingTableCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setData(data: data, cellType: .cartTableCell)
        cell.actionButtonClicked = { [weak self] in
            self?.deleteCartItem(dataDictionary: data)
        }
        return cell
    }
    
    func deleteCartItem(dataDictionary:[String:Any]){
        var cartArrayData = AppUtility.getArrayDictionaryFromDefaults(key:"ClassBookingCartData")
        var clasBokingDataArray = [ClassBookingItems]()
    
        do {
            clasBokingDataArray = try context.fetch(ClassBookingItems.fetchRequest())
        }catch {
            print(error)
        }
            
            for (index ,data) in cartArrayData.enumerated() {
                if data["id"] as! Int32 == dataDictionary["id"] as! Int32 {
                    cartArrayData.remove(at: index)
                    for ele in clasBokingDataArray {
                        if ele.id == data["id"] as! Int32 {
                            let availableCount = (Int(ele.available) + Int(data["available"] as! Int32))
                            updateItem(data: ele, available: Int32(availableCount), added: false, booked: false)
                        }
                    }
                }
                
            }
            AppUtility.saveArrayDictionaryToDefaults(arrayDictionary: cartArrayData, key: "ClassBookingCartData")
            DispatchQueue.main.async { [weak self] in
                self?.loadData()
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
    
}

extension ClassCartViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

