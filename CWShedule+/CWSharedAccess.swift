//
//  CWSharedAccess.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 12/31/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import Foundation

class CWSharedAccess{
    
    private static let _shared = CWSharedAccess()
    
    static var shared:CWSharedAccess{
        return _shared
    }
    
    let cwSharedDefaults = UserDefaults(suiteName: "group.codesworth.CWSchedule-")
    
}
