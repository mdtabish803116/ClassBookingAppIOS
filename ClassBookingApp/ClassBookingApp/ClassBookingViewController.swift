//
//  ViewController.swift
//  ClassBookingApp
//
//  Created by Tabish on 08/08/23.
//

import UIKit

class ClassBookingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartCoutLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var randomelementLable: UILabel!
    var timer : Timer?
    var counter = 60
    let viewModal  =  ClassBookingViewModal()
    var leftSeatCount = 10
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerTablevViewCell()
        setCartCountLabel()
        counter = viewModal.generateRandomNumber(30, 60)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decreseTime), userInfo: nil, repeats: true)
        leftSeatCount = viewModal.generateRandomNumber(5, 15)
        randomelementLable.text = "\(leftSeatCount)"
    }
    
    @objc func decreseTime(){
        counterLabel.text = "\( counter) Seconds"
        counter-=1
        if counter == 0 {
         counter = viewModal.generateRandomNumber(30, 60)
        }
    }
    
    func setCartCountLabel(){
        cartCoutLabel.text = "0"
        cartCoutLabel.textColor = .white
    }
    
    func registerTablevViewCell(){
        tableView.registerCellNib(ClassBookingTableCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadData()
    }
    
    func loadData(){
        viewModal.fetchAllItems {
            DispatchQueue.main.async { [weak self] in
                let cartArrayData = AppUtility.getArrayDictionaryFromDefaults(key:"ClassBookingCartData")
                 var cartCount = 0
                for data in cartArrayData {
                    cartCount += Int(data["available"] as? Int32 ?? 0)
                }
                if self?.leftSeatCount == 0 {
                    self?.leftSeatCount = self?.viewModal.generateRandomNumber(5, 15) ?? 10
                }
                self?.cartCoutLabel.text = "\(cartCount)"
                self?.randomelementLable.text = "\(self?.leftSeatCount ?? 10)"
                self?.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func onCartButtonClicked(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let classCartVC = mainStoryboard.instantiateViewController(withIdentifier: "ClassCartViewController") as! ClassCartViewController
        navigationController?.pushViewController(classCartVC, animated: false)
    }
    
}

extension ClassBookingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.ClassDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataArray = viewModal.ClassDataArray
        guard dataArray.count > indexPath.row else { return UITableViewCell() }
        
        let data = dataArray[indexPath.row]
        return getClassBookingTableCell(for: indexPath , data : data)
    }
    
    private func getClassBookingTableCell(for indexPath:IndexPath,data:ClassBookingCellData) -> UITableViewCell{
        let cell: ClassBookingTableCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setData(data: data.data,cellType:data.cellType)
        cell.actionButtonClicked = { [weak self] in
            self?.updateClassBookingData(data: data)
        }
        return cell
    }
    
    func updateClassBookingData(data:ClassBookingCellData){
        Task {
            await viewModal.getAllItems()
            for ele in viewModal.classModals {
                if ele.id == data.data["id"] as! Int32 {
                    var cartArrayData = AppUtility.getArrayDictionaryFromDefaults(key:"ClassBookingCartData")
                   
                    if calculateCartCount(dataArray:cartArrayData) >= 3 {
                        showAlert(message: "You can not schedule more than 3 seats in a week")
                        return
                    }
                    
                    if ele.added {
                        for (index , data) in cartArrayData.enumerated() {
                          if ele.id == data["id"] as! Int32 {
                            var availableCount = data["available"] as? Int32 ?? 0
                                availableCount += 1
                              cartArrayData[index]["available"] = availableCount
                              break
                                }
                            }
                        AppUtility.saveArrayDictionaryToDefaults(arrayDictionary: cartArrayData, key: "ClassBookingCartData")
                    }else {
                        ele.added = true
                        if ele.available == 0 {
                            ele.booked = true
                        }
                           var data = data.data
                             data["available"] = 1
                             data["added"] = true
                             ele.booked ? ( data["booked"] = true) : ( data["booked"] = false)
                        cartArrayData.append(data)
                        print("dataArray" , cartArrayData)
                          AppUtility.saveArrayDictionaryToDefaults(arrayDictionary: cartArrayData, key: "ClassBookingCartData")
                    }
                   
                    ele.available = ele.available - 1
                    leftSeatCount = leftSeatCount - 1
                    ele.added = true
                    if ele.available == 0 {
                        ele.booked = true
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.viewModal.updateItem(data: ele, available: ele.available , added: ele.added, booked: ele.booked)
                        self?.loadData()
                        self?.showAlert(message: "item added to cart successfully")
                    }
                   
                }
            }
        }
        
    }
    
    func calculateCartCount(dataArray:[[String:Any]]) -> Int{
         var cartCount = 0
        for data in dataArray {
            cartCount += Int(data["available"] as? Int32 ?? 0)
        }
        return cartCount
    }
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
}

extension ClassBookingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

