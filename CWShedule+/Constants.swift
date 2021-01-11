//
//  Constants.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation
import UIKit




typealias ExecuteAfterFinish = () -> ()
typealias Execute = (() -> Void)?

var itemDictionary:Dictionary<Int64, Bool> = [:]

//MARK:- STRINGS_HOLDERS
let DURATION_SCHEDULE_ITEM__DEFAULT = "No Duration Set"
let _LOCK_STATE__ = "passcodeLock"
let _NOTIF__NAME_CELL_BUTTON = "cellForRow"
let ID_CWNOTIF_ACTION_SNOOZE = "snooze"
let ID_CWNOTIF_ACTION_RESCHED__ = "rschedule"
let ID_CWNOTIF_ACTION_MARK_COMPLTD__ = "complete"
let __DIRECTIVE_VOICE_RECOG_SCHEDULE_AD__ = "To Add a schedule please use the phrase Schedule plus 'Your schedule name' in goup 'Schedule group'. If group does not exist a new one will be crated or schedule item will be stored in default group"
let __KEYWORD_SCHEDULE__ = "schedule"
let __KEYWORD_SCHEDULE_GROUP_ = "group"
let __KEY_SPACE__ = " "
let __SCHEDULE_GROUP_DEFAULT = "Default"
let _IN_ = "in"
let __NO_SPACE_ = ""
let _IMG_DEFAULT__ = "sample"
let _DICT_KEY_DATE = "date"
let _DICT_KEY_SNSGA = "snNsgA"
let SHADOW_COLOR:CGFloat = 157.0 / 255

let KEY_PATH_CA_ANIM_ROTATE = "transform.rotation"
var itemToEditfromNotifID:Array<Int64> = []

//MARK:- BOOLS

var isFromHomeVC = true
var allScheduleisBackVC = false
var calendarIsBackVC = false

//MARK:- REUSE_IDENTIFIERS

let REUSE_IDENTIFIER_S_GROUP = "ScheduleGroupCell"

let REUSE_IDENTIFIER_S_ITEM = "ScheduleItemCell"

let REUSE_IDENTIFIER_REPEAT_CELL = "RepeatCells"

let RE_USE_IDENTIFIER_UPCOMING_CELL = "UpComingCells"

let RE_USE_IDENTIFIER_CALENDAR_CELLS = "CalenderCells"

let RESUSE_IDENTIFIER_ALL_ITEM_CELLS = "AllScheduleItems"

let REUSE_IDENTIFIER_ALL_CELLS_1_ = "AllSchedule1Cell"

let REUSE_ID_ALL_CELLS_2_ = "AllSchedule2Cell"

let REUSE_ID_ALL_CELLS_3_ = "AllSchedule3Cells"

let REUSE_ID_ALL_CELLS_4 = "AllSchedule_4Cell"

let REUSE_ID_FOLDINGCELL_ = "FoldingCell"


//MARK: - SEGUES

let SEGUE_ADD_NEW_SG = "AddNewSGroup"

let SEGUE_EDIT_SG = "EditSGroupSegue"

let SEGUE_SHEDULE_GROUP_ITEMS = "ScheduleGroupSegue"

let SEGUE_ADD_SCHEDULE_ITEM = "AddScheduleItem"

let SEGUE_SCHEDULE_ITEM_DETAILS = "ScheduleDetails"

let SEGUE_UPCOMING_ITEM_DETAILS = "UpComingItemDetailSegue"

let _SEGUE_ID_ALLSHEDULE_DETAIL__ = "SEGUEIDALLSHEDULEDETAIL"

let _SEGUE_ID_HOME_ALL_SCHEDULE_ = "homeToAllschedules"

let _SEGUE_ID_HOME_CALENDAR_ = "HomToCalendar"

let SEGUE_ALL_CALL = "AllToCall"


let SEGUE_CALL_ALL = "CallToall"

let SEGUE_HOME_TO_SETTINGS_ = "Settings"

let SEGUE_CAL_TO_ADD = "CalendarToAdd"
let SEGUE_TO_GROUP_SELECT_PAGE = "GroupSelectionPage"
//MARK: - STORYBOARD IDs

let ALL_SHEDULE_STORY_ID = "AllScheduleVC"
let ALL_SCHEDULE_NAVC_STORY_ID__ = "AllScheduleNavC"
let STORY_ID_HOMEVC__ = "HomeVC"
let __NAV_STORY_ID_HOMEVC__ = "NavController"
let __STORY_ID_CALENVC = "CalenderVC"
let __STORY_ID_PASCODE__ = "PasscodeScreen"
let __STORY_ID_ADDSCHED_ITEM = "AddSchedule"
let __STORY_ID_PAGE_CONTENT = "ContentVC"
let __STORY_ID_PAGECONTROLLER_ = "PageVC"

let KEY_SCHDSG_AUTODELETE_ = "auto"
let KEY_AUTODELETECOMPLETE_ = "autoremove"

//MAIL:- 
let MAIL_CWSHPLUS = "cwscheduleplus@gmail.com"

//MARK: - STRING VARIABLES

let NAME_OF_IMAGE_CHECKED =  "check"

let NAME_OF_IMAGE_UNCHECKED = "uncheck"

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

func blur(thisViewDarkStyle view:UIView){
    let blureffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blureffect)
    blurView.frame = view.bounds
    view.addSubview(blurView)
}

func dateDayFormat(date:NSDate) ->String{
    let dateformatter = DateFormatter()
    dateformatter.dateStyle = .short
    dateformatter.dateFormat = "yyy-MM-dd"
    let formatedDate = dateformatter.string(from: date as Date)
    return formatedDate
}


func setFormat(for date:Date) -> Date{
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.dateFormat = "dd-MMM-yyy"
    let formattedDate = formatter.string(from: date)
    let newdate = (formatter.date(from: formattedDate))!
    return newdate
    
}






func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }



}

func createAlert(title:String,actionTitle:String, message:String, controller:UIViewController,actionStyle:UIAlertActionStyle ,onComplete:(() -> Void)?){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: actionTitle, style:actionStyle , handler: nil)
    alert.addAction(action)
    controller.present(alert, animated: true, completion: onComplete)
}




