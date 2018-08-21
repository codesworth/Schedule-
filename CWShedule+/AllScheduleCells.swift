//
//  AllScheduleCells.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/10/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class AllScheduleCells: UITableViewCell {

    
    @IBOutlet weak var alphaStackView: UIStackView!
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemNotesLabel: UILabel!
    @IBOutlet weak var beginDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var itemLine: UIView!
    
     let repeatArray = ["Hourly", "Daily", "Weekly" ,"Monthly", "Annually", "Never"]
     let urgency = ["Urgent","Very urgent", "Extremely urgent"]
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 2.0
    }
    
    func updateCellUI(item:SheduleItem){
        let willReturnDate = datingInfo(date: item.sIBeginDate, nextDate: item.sIEndDate)
        itemNameLabel.text = item.sIName
        if item.childSDetails?.sDExtraDetails == "" && !willReturnDate{
            itemLine.isHidden = true
            secondStackView.isHidden = true
            thirdStackView.isHidden = true
            alphaStackView.distribution = .fillProportionally
        }
        else if !willReturnDate && item.childSDetails?.sDExtraDetails != "" {
                thirdStackView.isHidden = true
                alphaStackView.distribution = .fillProportionally
                itemNotesLabel.text = item.childSDetails?.sDExtraDetails
        }else if willReturnDate && item.childSDetails?.sDExtraDetails == "" {
                beginDate.text = configureString(date: item.sIBeginDate, nextdate: item.sIEndDate)
        }
        else{
            itemNotesLabel.text = item.childSDetails?.sDExtraDetails
            beginDate.text = configureString(date: item.sIBeginDate, nextdate: item.sIEndDate)
            endDate.text = "Remind \(repeatArray[Int((item.childSUrgency?.sURepeat)!)]). \(urgency[Int((item.childSUrgency?.sUUrgency)! - 1)])"
        }
        
    }
    
   private func datingInfo(date:NSDate?, nextDate:NSDate?)->Bool{
        if date == nil && nextDate == nil{
            return false
        }
        else if date != nil && nextDate == nil{
            return true
        }
        else if date == nil && nextDate != nil{
            return true
        }
        return true
    }
    
    private func configureString(date:NSDate?, nextdate:NSDate?)->String{
        if date == nil && nextdate != nil{
            return "Schedule ending on \((nextdate as! Date).monthAndDayFromat()). No specified starting date"
        }else if date != nil && nextdate == nil{
            return "Schedule begins on \((date as! Date).monthAndDayFromat()). "
        }
        else if date != nil && nextdate != nil{
            return "Schedule begins on \((date as! Date).monthAndDayFromat()) and ends \((nextdate as! Date).monthAndDayFromat())"
        }
        else {return ""}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
