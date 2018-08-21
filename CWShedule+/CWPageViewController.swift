//
//  CWPageViewController.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 3/2/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import UIKit

class CWPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sub:NSArray = view.subviews as NSArray
        var scroll:UIScrollView? = nil
        var pagecontrol:UIPageControl? = nil
        
        for v in sub{
            if v is UIScrollView {
                scroll = v as? UIScrollView
            }
            else if v is UIPageControl{
                pagecontrol = v as? UIPageControl
            }
        }
        if scroll != nil && pagecontrol != nil{
            scroll?.frame = UIScreen.main.bounds
            view.bringSubview(toFront: pagecontrol!)
        }
    }

}






class TSPageViewController: UIPageViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let subViews: NSArray = view.subviews as NSArray
        var scrollView: UIScrollView? = nil
        var pageControl: UIPageControl? = nil
        
        for view in subViews {
            if (view as AnyObject) is (UIScrollView) {
                scrollView = view as? UIScrollView
            }
            else if (view as AnyObject) is (UIPageControl) {
                pageControl = view as? UIPageControl
            }
        }
        
        if (scrollView != nil && pageControl != nil) {
            scrollView?.frame = view.bounds
            view.bringSubview(toFront: pageControl!)
        }
    }
}
