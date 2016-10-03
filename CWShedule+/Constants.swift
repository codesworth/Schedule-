//
//  Constants.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import UIKit


let REUSE_IDENTIFIER_S_GROUP = "ScheduleGroupCell"

let REUSE_IDENTIFIER_S_ITEM = "ScheduleItemCell"

let REUSE_IDENTIFIER_REPEAT_CELL = "RepeatCells"

let RE_USE_IDENTIFIER_UPCOMING_CELL = "UpComingCells"

//MARK: - SEGUES

let SEGUE_ADD_NEW_SG = "AddNewSGroup"

let SEGUE_EDIT_SG = "EditSGroupSegue"

let SEGUE_SHEDULE_GROUP_ITEMS = "ScheduleGroupSegue"

let SEGUE_ADD_SCHEDULE_ITEM = "AddScheduleItem"

let SEGUE_SCHEDULE_ITEM_DETAILS = "ScheduleDetails"

let SEGUE_UPCOMING_ITEM_DETAILS = "UpComingItemDetailSegue"





//MARK: - STRING VARIABLES

let NAME_OF_IMAGE_CHECKED =  "messageindicatorchecked2"

let NAME_OF_IMAGE_UNCHECKED = "messageindicator2"

// MARK: - GLOBAL FUNCTIONS

func nextSheduleItemID()-> Int{
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ScheduleItemID")
    userDefaults.set(itemID+1, forKey: "ScheduleItemID")
    userDefaults.synchronize()
    return itemID
}


func blur(thisView view:UIView){
    let blureffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blureffect)
    blurView.frame = view.bounds
    view.addSubview(blurView)
}
