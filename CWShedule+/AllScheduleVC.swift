 //
//  AllScheduleVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 10/9/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import CoreData

class AllScheduleVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UISearchBarDelegate,LiquidFloatingActionButtonDelegate,LiquidFloatingActionButtonDataSource {
    
    
    @IBOutlet weak var blurview: UIView!
    @IBOutlet weak var barbuttonContainer: UIBarButtonItem!
    @IBOutlet weak var barbutton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var voiceButton:UIButton!
    var newview:UIView!
    //MARK: - Properties
    var searchModeIsOn = false
    var fetchedResultsController:NSFetchedResultsController<SheduleItem>!
    var scheduleItems = [SheduleItem?]()
    var cameFromCalender = false
    //var cellHeight = [CGFloat]()
    var kCloseCellHeight:CGFloat = 82
    var kOpenCellHeight:CGFloat = 240
    var limit:Int!
    var indexHolder:IndexPath?
    var cellHeights = [CGFloat]()
    var shouldnotCallVDL = false
    var floatingButton:LiquidFloatingActionButton!
    var cells:[LiquidFloatingCell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        //tableView.estimatedRowHeight = 196
        tableView.delegate = self
        tableView.dataSource = self
        itemSearchBar.delegate = self
        shouldnotCallVDL = true
        itemSearchBar.setTextColor(color: .white)
        performFetch(index: nil)
        scheduleItems = []
        self.navigationItem.title = "Schedules"
        limit = fetchedResultsController.fetchedObjects?.count
        cellHeights = (0..<limit).map { _ in C.CellHeight.close }
        let _long__ = UILongPressGestureRecognizer(target: self, action: #selector(longpress))
        _long__.minimumPressDuration = 1
        voiceButton.addGestureRecognizer(_long__)

    }
    


    func longpress(){
        _ = navigationController?.popToRootViewController(animated: true)
        appDelegate?.voicable = true
    }

    
    
    func f_(){
        let frame = CGRect(x: self.view.frame.width - 40, y: self.view.frame.height - 100, width: 40, height: 40)
        floatingButton = LiquidFloatingActionButton(frame: frame)
        floatingButton.delegate = self
        floatingButton.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setFloatingbuttons()
        if !shouldnotCallVDL{
            viewDidLoad()
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if searchModeIsOn{
            shutsearch()
        }
        fetchedResultsController.relinquishDelagation()
        for v in view.subviews{
            if let f = v as? LiquidFloatingActionButton{
                f.close()
                break
            }
        }
        cells.removeAll()
        
    }
    
    private func performFetch(index:Int?){
        let fetchRequest:NSFetchRequest<SheduleItem> = SheduleItem.fetchRequest()
        let datesort = NSSortDescriptor(key: "sIcreatedDate", ascending: true)
        fetchRequest.sortDescriptors = [datesort]
        if index != nil{
            switch index! {
            case 0:
                let nameSort = NSSortDescriptor(key: "sIName", ascending: true)
                fetchRequest.sortDescriptors = [nameSort]
                break
            case 1:
                let dateStarted = NSSortDescriptor(key: "sIBeginDate", ascending: true)
                fetchRequest.sortDescriptors = [dateStarted]
                break
            case 2:
                let checked = NSSortDescriptor(key: "sItemChecked", ascending: true)
                fetchRequest.sortDescriptors = [checked, datesort]
                break
            default:
                break
            }
        }else{fetchRequest.sortDescriptors = [datesort]}
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch let error as NSError{
            print("Error occurred with signature: ", error.debugDescription)
        }
        
    }
    
    
    @IBAction func showGroupVC(_ sender: Any) {
        fetchedResultsController.delegate = nil
        shouldnotCallVDL = false
        let nav = storyboard?.instantiateViewController(withIdentifier: "nav") as! UINavigationController
        present(nav, animated: true, completion: {})
        
    }
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {

        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func calenderButtonPressed(_sender:AnyObject){
        
        performSegue(withIdentifier: SEGUE_ALL_CALL, sender: nil)
    }
    
    func seaarch(lql:LiquidFloatingActionButton) {
        
        if !searchModeIsOn{

            tableView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.tableView.frame.origin.y += 40
                self.tableView.frame.size.height -= 40
                self.itemSearchBar.frame.size.height += 40
            }, completion: { Bool in
                self.searchModeIsOn = true
            })
            
        }else{
            shutsearch()
            lql.close()

        }
    }
    
    //MARK: - VIEW MANIPULATIONS
    
    func shutsearch(){
        tableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.itemSearchBar.frame.size.height -= 40
            self.tableView.frame.size.height += 40
            self.tableView.frame.origin.y -= 40
                    }, completion:{ Bool in
            self.searchModeIsOn = false
            self.view.endEditing(true)
            self.tableView.reloadData()
        })

    }
    
    //MARK: - DELEGATES
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK:- UISEARCHBAR DELEGATES
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        scheduleItems.removeAll()
        //scheduleItems = CoreService.service.performFetchFromSearch(string: searchText, itemName: "sIName")
        let f = fetchedResultsController.fetchedObjects! as [SheduleItem]
        for item in f{
            if item.sIName!.contains(searchText){
                scheduleItems.append(item)
            }
        }

        tableView.reloadData()

        tableView.isUserInteractionEnabled = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        if searchModeIsOn{
            return 1
        }else{
            if let section = fetchedResultsController.sections{
                return section.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchModeIsOn{
            return scheduleItems.count
        }else{
            if let sections = fetchedResultsController.sections{
                let objects = sections[section]
                limit = objects.numberOfObjects
                return objects.numberOfObjects
            }
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item:SheduleItem
        if searchModeIsOn{
            item = scheduleItems[indexPath.row]!
        }else{
            item = fetchedResultsController.object(at: indexPath)
            
            
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_ID_FOLDINGCELL_, for: indexPath) as? FoldAllScheduleCell{
            cell.configureCell(item: item)
            cell.button.addTarget(self, action: #selector(performSeg), for: .touchUpInside)
            return cell
        }
        return FoldingCell()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexHolder = indexPath

        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                cell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                cell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    //MARK:- LIQUID FLOATING DELEGATES
    
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(_ index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        switch index {
        case 0:
            seaarch(lql: liquidFloatingActionButton)
            break
        case 1:
            performFetch(index: 0)
            liquidFloatingActionButton.close()
                tableView.reloadData()
            break
        case 2:
            performFetch(index: 1)
            liquidFloatingActionButton.close()
                tableView.reloadData()
            break
        case 3:
            performFetch(index: 2)
            liquidFloatingActionButton.close()
                tableView.reloadData()
            break
        default:
            break
        }
    
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break
        case .update:
            if let indexPath = indexPath{

                let item = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as? FoldAllScheduleCell
                cell?.configureCell(item: item)
            }
            break
        }
        
    }
    
    
}




extension AllScheduleVC{
    


    
    func performSeg(){
        
        let indexPath = indexHolder
        guard indexPath == nil else{
            let item = fetchedResultsController.object(at: indexPath!)
            performSegue(withIdentifier: _SEGUE_ID_ALLSHEDULE_DETAIL__, sender: item)
            
            cellHeights[indexPath!.row] = C.CellHeight.opened
            return
        }

    }

    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == _SEGUE_ID_ALLSHEDULE_DETAIL__{
            if let vc = segue.destination as? AddScheduleItemVC{
                if sender != nil{
                    let item = sender as! SheduleItem
                    vc.sheduleItemToEdit = item
                }else{
                    
                }
            }
        }
    }
    
    func setFloatingbuttons(){
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = CustomDrawingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            floatingActionButton.color = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
            floatingActionButton.rotationDegrees = 90
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
            return cell
        }
        let customCellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = CustomCell(icon: UIImage(named: iconName)!, name: iconName)
            return cell
        }
        cells.append(cellFactory("Search"))
        cells.append(customCellFactory("az1"))
        cells.append(cellFactory("Due"))
        cells.append(cellFactory("chkd") )
        
        //let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        //let bottomRightButton = createButton(floatingFrame, .up)
        
        _ = UIImage(named: "ic_art")
        //bottomRightButton.image = image
        
        _ = CGRect(x: 16, y: 60, width: 40, height: 40)
        let flframe = CGRect(x: 4, y: self.view.frame.height - 105, width: 40, height: 40)
        let topLeftButton = createButton(flframe, .up)
        
        //self.view.addSubview(bottomRightButton)
        //self.barbuttonContainer.customView?.addSubview(topLeftButton)
        self.view.addSubview(topLeftButton)
    }
    
    func overlayview()->UIView{
        let newview = UIView(frame: view.frame)
        newview.center = view.center
        newview.backgroundColor = UIColor.gray
        newview.alpha = 0.4
        return newview
    }
    
    fileprivate struct C {
        struct CellHeight {
            static let close:CGFloat = 82
            static let opened:CGFloat = 240
        }
    }
    
    
}

 
 
 public class CustomCell : LiquidFloatingCell {
    var name: String = "sample"
    
    init(icon: UIImage, name: String) {
        self.name = name
        super.init(icon: icon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView(_ view: UIView) {
        super.setupView(view)
        /*let label = UILabel()
        label.text = name
        label.textColor = UIColor.white
        label.font = UIFont(name: "Helvetica-Neue", size: 12)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(self).offset(-80)
            make.width.equalTo(75)
            make.top.height.equalTo(self)
        }*/
    }
 }

 
 class CustomDrawingActionButton: LiquidFloatingActionButton {
    override func createPlusLayer(_ frame: CGRect) -> CAShapeLayer {
        let plusLayer = CAShapeLayer()
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = UIColor.black.cgColor
        plusLayer.lineWidth = 3.0
        //plusLayer.backgroundColor = UIColor.lightGray.cgColor
        //plusLayer.cornerRadius = plusLayer.frame.width / 2
        
        let w = frame.width
        let h = frame.height
        
        let points = [
            (CGPoint(x: w * 0.25, y: h * 0.35), CGPoint(x: w * 0.75, y: h * 0.35)),
            (CGPoint(x: w * 0.25, y: h * 0.5), CGPoint(x: w * 0.75, y: h * 0.5)),
            (CGPoint(x: w * 0.25, y: h * 0.65), CGPoint(x: w * 0.75, y: h * 0.65))
        ]
        
        let path = UIBezierPath()
        for (start, end) in points {
            path.move(to: start)
            path.addLine(to: end)
        }
        
        plusLayer.path = path.cgPath
        
        return plusLayer
    }
    
    override func open() {
        super.open()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NOTIF_CL_NAV)))
        
    }
    
    override func close() {
        super.close()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NOTIF_PR_NAV)))
    }
 }
 
 extension NSFetchedResultsController{
    
    func relinquishDelagation(){
        delegate = nil
    }
 }

let NOTIF_CL_NAV = "ClearNav"
let NOTIF_PR_NAV = "PresentNav"
