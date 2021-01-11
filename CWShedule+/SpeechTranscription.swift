//
//  SpeechTranscription.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/30/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

let instructions = ["Hello, Welcome To Schedule+", "Please press record to start voice scheduling", "You can specify the schedule group for your schedule by using the phrase ... in ('Your Schedule group name')","Please be sure to specify 'AM' or 'PM' when adding starting date to voice schedule", "Press Save to save schedule", "E.g: “Meeting on Thursday 3:30 PM in group Projects”", "Pick up Jake Tomorrow at 11A M", "'Frances Birthday on November 3rd in group Birthdays'"]

import Foundation

/*
 Methods defined to operate on string data received from Speech to text Apple Engine 
 Methods here mainly work to refine result to conform to the CWSchedule+ mechanism for adding Schedules
 */

class TranscriptionService{
    
    private static let _mainService = TranscriptionService()
    
    static var mainService:TranscriptionService{
        return _mainService
    }
    
    var defaultTimeset:String!
    var beginTime:Int!
    
    func starttranscripting(voiceText:String)-> Dictionary<String,AnyObject>{
        var stringArray = voiceText.components(separatedBy: __KEY_SPACE__)
        var newArray = Array<String>()
        var schedulenameArray = Array<String>()
        var groupNameArray = Array<String>()
        var schedeuleGroup:String
        var schedulename:String
        var returnDict = Dictionary<String, AnyObject>()
        var returnArray = Array<String>()
        
        let beginDate = detectDate(string: voiceText)
        returnDict[_DICT_KEY_DATE] = beginDate as AnyObject?

        let n_s = stringArray.joined(separator: __KEY_SPACE__)
        let refined = composestring(s: n_s)
        stringArray = refined.components(separatedBy: __KEY_SPACE__)
        guard stringArray.index(of: __KEYWORD_SCHEDULE__.capitalized) == nil else {
            let index = stringArray.index(of:__KEYWORD_SCHEDULE__.capitalized )
                let intIndex = Int(index!)
                for x in (intIndex + 1)...(stringArray.count - 1) {
                newArray.append(stringArray[x])
            }
                let groupIndex = newArray.index(of: __KEYWORD_SCHEDULE_GROUP_)
                if groupIndex != nil{
                    let intIndex2 = Int(groupIndex!)
                    for y in 0...(intIndex2 - 1){
                        schedulenameArray.append(newArray[y])
                    }
                    for x in (intIndex2 + 1)...(newArray.count - 1){
                        groupNameArray.append(newArray[x])
                    }
                    if schedulenameArray[schedulenameArray.endIndex - 1] == _IN_{
                        schedulenameArray.remove(at: schedulenameArray.endIndex - 1)
                    }
                    schedeuleGroup = groupNameArray.joined(separator: __KEY_SPACE__)
                    schedulename = schedulenameArray.joined(separator: __KEY_SPACE__)
                    returnArray.append(schedulename)
                    returnArray.append(schedeuleGroup)
                }else{
                    if newArray[newArray.endIndex - 1] == _IN_{
                        newArray.remove(at: newArray.endIndex - 1)
                    }
                    schedulename = newArray.joined(separator: __KEY_SPACE__)
                    schedeuleGroup = __SCHEDULE_GROUP_DEFAULT
                    returnArray.append(schedulename)
                    returnArray.append(schedeuleGroup)
                    
                }
            returnDict[_DICT_KEY_SNSGA] = returnArray as AnyObject
           return returnDict
        }
        let groupIndex = stringArray.index(of: __KEYWORD_SCHEDULE_GROUP_)
        if groupIndex != nil{
            for x in 0...groupIndex! - 1{
                schedulenameArray.append(stringArray[x])
            }
            for x in (groupIndex! + 1)...stringArray.count - 1{
                groupNameArray.append(stringArray[x])
            }
            if schedulenameArray[schedulenameArray.endIndex - 1] == _IN_{
                schedulenameArray.remove(at: schedulenameArray.endIndex - 1)
            }
            schedulename = schedulenameArray.joined(separator: __KEY_SPACE__)
            schedeuleGroup = groupNameArray.joined(separator: __KEY_SPACE__)
            returnArray.append(schedulename)
            returnArray.append(schedeuleGroup)
        }else{
            if stringArray[stringArray.endIndex - 1] == _IN_{
                stringArray.remove(at: stringArray.endIndex - 1)
            }
            schedulename = stringArray.joined(separator: __KEY_SPACE__)
            schedeuleGroup = __SCHEDULE_GROUP_DEFAULT
            returnArray.append(schedulename)
            returnArray.append(schedeuleGroup)
        }
        
        
        returnDict[_DICT_KEY_SNSGA] = returnArray as AnyObject
        return returnDict
    }
    
    
    
    func detectDate(string:String)->Date?{
        if string.isEmpty{
            return nil
        }
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        if !matches.isEmpty {return matches[0].date}
        return nil
    }
    
    func cleanup(string:String)-> String?{
        
        /*var __ = Array<Months>()
        __ = [.January, .Febuary, .March,.April,.May,.June,.July,.August,.September,.October,.November,.December, .One, .Two, .Three, .Four, .Five, .Six, .Seven, .Eight,.Nine, .Ten, .Eleven, .Twelve, .Zero]
        for a in __ {
            if string.capitalized == a.rawValue{
                return nil
            }
        }
        var __a = Array<Days>()
        __a = [.Sunday, .Monday, .Tuesday, .Wednesday,.Thursday, .Friday, .Sunday, .Tomorrow, .NextWeek,.Today, .AM, .PM, .AT]
        for m in __a{
            if string.capitalized == m.rawValue{
                return nil
            }
        }*/
        if string.contains(":") || string.capitalized.contains("At") || string.capitalized.contains("AM") || string.capitalized.contains("PM"){
            return nil
        }
        
        if Int(string) != nil{
            return nil
        }

        return string
    }
    
    func composestring(s:String)->String{
        let array = s.components(separatedBy: __KEY_SPACE__)
        var returnArray:[String] = []
        for e in array{
           let i = cleanup(string: e)
            if i != nil{returnArray.append(i!)}
        }
        let string = returnArray.joined(separator: __KEY_SPACE__)
        return string
    }
    
    
}



extension TranscriptionService{
    enum Days:String {
        case Monday = "Monday"
        case Tuesday = "Tuesday"
        case Wednesday = "Wednesday"
        case Thursday = "Thursday"
        case Friday = "Friday"
        case Saturday = "Saturday"
        case Sunday = "Sunday"
        case Today = "Today"
        case Tomorrow = "Tomorrow"
        case NextWeek = "Next week"
        case PM = "Pm"
        case AM = "Am"
        case AT = "At"
        
    }
    
    enum Months:String {
        case January = "January"
        case Febuary = "Febuary"
        case March = "March"
        case April = "April"
        case May = "May"
        case June = "June"
        case July = "July"
        case August = "August"
        case September = "September"
        case October = "October"
        case November = "November"
        case December = "December"
        case Zero = "Zero"
        case One = "One"
        case Two = "Two"
        case Three = "Three"
        case Four = "Four"
        case Five = "Five"
        case Six = "Six"
        case Seven = "Seven"
        case Eight = "Eight"
        case Nine = "Nine"
        case Ten =  "Ten"
        case Eleven = "Eleven"
        case Twelve = "Twelve"
    }
}


