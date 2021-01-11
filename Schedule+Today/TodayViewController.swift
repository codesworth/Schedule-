//
//  TodayViewController.swift
//  Schedule+Today
//
//  Created by Mensah Shadrach on 12/5/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var upcomingSchedules:[SheduleItem]!
    var fetchRequest:NSFetchRequest<NSFetchRequestResult>!
    let appUrl = (URL(string: "CWSchedules://"))!
    override func viewDidLoad() {
        super.viewDidLoad()
        awakeAndRegisterCellNib()
        tableView.delegate = self
        tableView.dataSource = self
        upcomingSchedules = []
        performFetch()
        tableView.estimatedRowHeight = 60
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    
        //let newSshecfules = performFetch()
        //print(newSshecfules)
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        performFetch()
        tableView.reloadData()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact{
            preferredContentSize = maxSize
        }else{
            preferredContentSize = CGSize(width: maxSize.width, height: 380)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(upcomingSchedules.count)
        return upcomingSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = upcomingSchedules[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: ID_TODAY_CELLS, for: indexPath) as? TodayCells{
            cell.configureCells(item: item)
            return cell
        }
        return TodayCells()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = upcomingSchedules[indexPath.row].sItemID
        extensionContext?.open(appUrl, completionHandler: { (Bool) in
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Reschedule"), object: nil, userInfo: ["item":item])
            CWSharedAccess.shared.cwSharedDefaults?.set(item, forKey: "key")
            CWSharedAccess.shared.cwSharedDefaults?.set(true, forKey: "canOpen")
        })
        
    }
    
    func awakeAndRegisterCellNib(){
        let nib = UINib(nibName: ID_TODAY_CELLS, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ID_TODAY_CELLS)
    }
    func performFetch(){
        let date = NSDate()
        let predicate = NSPredicate(format: "sIBeginDate >= %@", date)
        let model = CoreDataStack.managedObjectModel
        fetchRequest = (model.fetchRequestTemplate(forName: "TodayFetch"))!.copy() as? NSFetchRequest
        fetchRequest.predicate = predicate
        let sort:NSSortDescriptor = NSSortDescriptor(key: "sIBeginDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do{
            upcomingSchedules = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest) as? [SheduleItem]
            
            tableView.reloadData()
        }catch let error as NSError{
            print("Error with signature: ", error)
        }
        
    }
    
}
