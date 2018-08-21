//
//  AppDelegate.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 9/20/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var finishedFirstRun = false
    var window: UIWindow?
    let newwindow = UIWindow(frame: UIScreen.main.bounds)
    
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    var  appIsSecured = false
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        appIsSecured = UserDefaults.standard.bool(forKey: __APP_SECURED__)
        if appIsSecured{
            //window?.rootViewController = nil
            let rvc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: __STORY_ID_PASCODE__) as! PasscodeVC
            newwindow.rootViewController = rvc
            print(UIApplication.shared.keyWindow?.rootViewController?.description ?? "fddffdddfdf")
            newwindow.makeKeyAndVisible()
            
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        


        

        self.setRootVC()
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.statusBarStyle = .lightContent
        let navAppearance = UINavigationBar.appearance()
        navAppearance.barTintColor = UIColor.black
        //(red: 5/255/*195/255*/, green: 92/255/*195/255*/, blue: 91/255/*195/255*/, alpha: 1)
        navAppearance.tintColor = UIColor.white//(red: 5/255/*195/255*/, green: 92/255/*195/255*/, blue: 91/255/*195/255*/, alpha: 1)
        navAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        _ = UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, erorr) in
            if granted{
                print("Granted")
            }else{
                print((erorr as! NSError).debugDescription)
            }
        }
        configureUNUserNotifications()
        setpageControls()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.


        secureApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.


        secureApp()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //        let itemID = UserDefaults.standard.value(forKey: "notifs") as! Array<Int64>
        //        print(itemID)
        contextFromToday()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStack.saveContext()
    }
    
    // MARK: - Core Data stack
    

    
    func configureUNUserNotifications(){
        let rescheduleAction = UNNotificationAction(identifier: ID_CWNOTIF_ACTION_RESCHED__, title: "Reschedule", options: [.foreground])
        let snoozeAction = UNNotificationAction(identifier: ID_CWNOTIF_ACTION_SNOOZE, title: "Snooze", options: [])
        let markCompleted = UNNotificationAction(identifier: ID_CWNOTIF_ACTION_MARK_COMPLTD__, title: "Mark As Completed", options: [])
        let category = UNNotificationCategory(identifier: NSNOTIF_CATEGORY_ID__, actions: [snoozeAction,rescheduleAction, markCompleted], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notifs"), object: .none)
        completionHandler(.alert)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == ID_CWNOTIF_ACTION_MARK_COMPLTD__{
            print("it is done Thank u")
            let itemID = response.notification.request.content.userInfo["itemID"] as! Int64
            let item = CoreService.service.performFetchwith(itemID: itemID)
            print(item)
            item.sItemChecked = true
            CoreDataStack.saveContext()
            completionHandler()
        }
        else if response.actionIdentifier == ID_CWNOTIF_ACTION_SNOOZE{
            let itemID = response.notification.request.content.userInfo["itemID"] as! Int64
            let item = CoreService.service.performFetchwith(itemID: itemID)
            print(item)
            ScheduleNotifications.notification.reScheduleNotification(item: item)
            let ids = response.notification.request.content.userInfo
            
            completionHandler()
        }else if response.actionIdentifier == ID_CWNOTIF_ACTION_RESCHED__{
            let itemID = response.notification.request.content.userInfo["itemID"] as! Int64
            let item = CoreService.service.performFetchwith(itemID: itemID)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Reschedule"), object: nil, userInfo: ["item" : item])

            completionHandler()
        }
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //
    }
    
    func secureApp(){
        appIsSecured = UserDefaults.standard.bool(forKey: __APP_SECURED__)
        if appIsSecured {
        let rVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: __STORY_ID_PASCODE__)
        newwindow.rootViewController = rVC
        newwindow.makeKeyAndVisible()
        }
    }
    func contextFromToday(){
        let canOpen = CWSharedAccess.shared.cwSharedDefaults?.bool(forKey: "canOpen")
        print(canOpen!)
        if (CWSharedAccess.shared.cwSharedDefaults?.bool(forKey: "canOpen"))!{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "open"), object: nil, userInfo: nil)

        }
    }
    func setpageControls(){
        let pagecontrol = UIPageControl.appearance()
        pagecontrol.pageIndicatorTintColor = UIColor.lightGray
        pagecontrol.currentPageIndicatorTintColor = UIColor.black
        pagecontrol.backgroundColor = UIColor.white
    }
    
    func setRootVC(){
        finishedFirstRun = UserDefaults.standard.bool(forKey: "firstRun")
        if finishedFirstRun{

                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: __NAV_STORY_ID_HOMEVC__) as! UINavigationController
            
        }else{
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "tutsVC")
            UserDefaults.standard.set(true, forKey: "firstRun")
        }
    }
}


let appDelegate = UIApplication.shared.delegate as? AppDelegate


let context = CoreDataStack.persistentContainer.viewContext


