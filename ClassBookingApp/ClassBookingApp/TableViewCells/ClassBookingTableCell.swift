//
//  ClassBookingTableCell.swift
//  ClassBookingApp
//
//  Created by Tabish on 08/08/23.
//

import UIKit

class ClassBookingTableCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var bookLable: UILabel!
    @IBOutlet weak var bookView: UIView!
    
    var actionButtonClicked : () -> () = {}
    var classData = [String:Any]()
    var cartData = [String:Any]()
    var bookingCellType: ClassBookingCellTypes = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data:[String:Any],cellType:ClassBookingCellTypes){
        if cellType == .cartTableCell {
            cartData = data
            bookingCellType = .cartTableCell
        }else {
            classData = data
            bookingCellType = .tableCell
        }
       
        dateLabel.text = data["date"] as? String
        timeLabel.text = data["time"] as? String
        availableLabel.text = "\(data["available"] as? Int32 ?? 0) seats"
        if cellType == .tableCell {
            if data["booked"] as! Bool{
                bookLable.text = "Full"
                bookView.backgroundColor = .systemPink
            }else {
                bookLable.text = "Book Now"
                bookView.backgroundColor = .orange
            }
        }else if cellType == .cartTableCell{
            bookLable.text = "Cancel"
            bookView.backgroundColor = .orange
        }
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        if bookingCellType == .tableCell {
            if !(classData["booked"] as! Bool) {
                actionButtonClicked()
            }
        }else {
              actionButtonClicked()
        }
        
    }
    
}
