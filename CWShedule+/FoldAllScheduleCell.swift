//
//  FoldAllScheduleCell.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/25/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit

class FoldAllScheduleCell: FoldingCell {

    @IBOutlet weak var extraNotesView: UITextView!
    @IBOutlet weak var scheduleuUrgencyView: UISegmentedControl!
    @IBOutlet weak var scheduleRemindswitch: UISwitch!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var scheduleGroupLabel: UILabel!
    @IBOutlet weak var scheduleNameUnLabel: UILabel!
    @IBOutlet weak var ScheduleDurationLabel: UILabel!
    @IBOutlet weak var schedulenameLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var button:UIButton!
    
    let repeatArray = ["Hourly", "Daily", "Weekly" ,"Monthly", "Annually", "Never"]
    let urgency = ["Urgent","Very urgent", "Extremely urgent"]
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 5
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        //button.layer.cornerRadius = 3.0
        button.backgroundColor = UIColor.clear
        //scheduleRemindswitch.isUserInteractionEnabled = false
        extraNotesView.backgroundColor = UIColor.gray
        extraNotesView.layer.cornerRadius = 5
        scheduleuUrgencyView.isUserInteractionEnabled = false
    }
    
    func configureCell(item:SheduleItem){
      schedulenameLabel.text = item.sIName?.capitalized
        scheduleGroupLabel.text = item.childSGroup?.sGName?.capitalized ?? "*No Group*"
         //scheduleRemindswitch.isOn = item.childSUrgency!.sUSetReminder
        if item.childSDetails?.sDExtraDetails == "" {
            extraNotesView.text = "**No Additional Notes On Schedule**"
        }else{
            extraNotesView.text = item.childSDetails?.sDExtraDetails
        }
        
        ScheduleDurationLabel.text = item.sItemDuration
        if item.sIBeginDate != nil{
            timingLabel.text = __(date: item.sIBeginDate!)
        }else{
            timingLabel.text = ""
        }
        scheduleNameUnLabel.text = item.sIName?.capitalized
        repeatLabel.text = "Remind: \(repeatArray[Int(item.childSUrgency!.sURepeat)])"
        if item.sItemChecked{
            checkMarkImageView.image = UIImage(named: NAME_OF_IMAGE_CHECKED)
        }else{
            checkMarkImageView.image = UIImage(named: NAME_OF_IMAGE_UNCHECKED)
        }
        //scheduleRemindswitch.setOn(item.sItemChecked, animated: true)
        self.scheduleuUrgencyView.selectedSegmentIndex = Int64((item.childSUrgency?.sURepeat)!) - 1
    }
    

    
    private func __(date:NSDate)-> String{
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.dateComponents([.hour,.minute], from: date as Date)
        if component.hour! < 10 && component.minute! < 10{
          return "0\(component.hour!):0\(component.minute!)"
        }else if component.hour! >= 10 && component.minute! < 10{
            return "\(component.hour!):0\(component.minute!)"}
        else if component.hour! < 10 && component.minute! >= 10{
            return "0\(component.hour!):\(component.minute!)"}
        
        let time = "\(component.hour!):\(component.minute!)"
        return time
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configButton(tableView:UITableView){
       //indexPath = tableView.indexPath(for: self)
    }
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.33] // timing animation for each view
        return durations[itemIndex]
    }

    @IBAction func buttonTapped(_ sender: UIButton) {

    }
}



