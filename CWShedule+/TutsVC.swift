//
//  TutsVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 1/1/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import UIKit

class TutsVC: UIViewController,UIPageViewControllerDataSource {

    @IBOutlet weak var skipbutton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var pageController:TSPageViewController!
    var pageTitles:[String]!
    var pageImages:[String]!
    var dismissible = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 3.0
        skipbutton.layer.cornerRadius = 3.0
        pageTitles = ["Home", "Voice Scheduling", "Schedule Groups","Calendar","Calendar","Schedules", "Schedules", "today"]
        pageImages = ["1", "2", "3", "4", "5","6","7","8"]
        
        pageController = storyboard?.instantiateViewController(withIdentifier: "PageVC") as! TSPageViewController
        pageController.dataSource = self
        let startingVC = viewController(at: 0) as! PageContentVC
        let viewcontrollers = [startingVC]
        pageController.setViewControllers(viewcontrollers, direction: .forward, animated: false, completion: nil)
        pageController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50)
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParentViewController: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController.view.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height );
        let v = view.viewWithTag(3) as? UIImageView
        let v2 = view.viewWithTag(4) as? UIImageView
        if v != nil && v2 != nil{
            view.bringSubview(toFront: v!)
            view.bringSubview(toFront: v2!)
        }
        view.bringSubview(toFront: skipbutton)
        view.bringSubview(toFront: startButton)
    
    }
    
    
    func viewController(at:Int)->UIViewController?{
        if pageTitles.count == 0 || at >= pageTitles.count{
            return nil
        }
        let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "ContentVC") as! PageContentVC
        pageContentVC.imageFile = pageImages[at]
        
        pageContentVC.pageIndex = UInt(at)
        
        return pageContentVC
    }

    

    @IBAction func restart(_ sender: Any) {
        let startingViewController = self.viewController(at: 0) as! PageContentVC
        let viewControllers = [startingViewController]
        self.pageController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: { _ in })
    }
  

 
    @IBAction func skip(_ sender: Any) {
        if dismissible{
            dismiss(animated: true, completion: nil)
        }else{
            let nav = storyboard?.instantiateViewController(withIdentifier: __NAV_STORY_ID_HOMEVC__) as? UINavigationController
            present(nav!, animated: true, completion: {})
        }

    }

    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentVC).pageIndex
        if (Int(index) == NSNotFound) {
            return nil
        }
        index += 1
        if Int(index) == self.pageTitles.count {
            return nil
        }
        return self.viewController(at: Int(index))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentVC).pageIndex
        if Int(index) == 0 || Int(index) == NSNotFound {
            return nil
        }
        index -= 1

        return self.viewController(at: Int(index))
    }
    
   /* func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }*/


}
