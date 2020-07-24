//
//  LibrarySearchPageViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-11.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit

class LibrarySearchPageViewController: UIPageViewController {
    var currentind = 0
    lazy var orderedViewControllers: [UIViewController] = {
        
        return [self.getViewController(viewController: "libraryplaylist"),
                self.getViewController(viewController: "libraryalbums"),
                self.getViewController(viewController: "librarysongs")
                ]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstViewController = orderedViewControllers.first
        {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.preferredContentSize = self.children[0].preferredContentSize
        
        addobservers()
        
        

        // Do any additional setup after loading the view.
    }
    
    func getViewController(viewController: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }

}
extension LibrarySearchPageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource, pagecontrollerprotocol
{
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {return nil}
                  
        let previousIndex = viewControllerIndex - 1
                  
                  // User is on the first view controller and swiped left to loop to
                  // the last view controller.
        guard previousIndex >= 0 else
        {
            
            return orderedViewControllers.last
                      // Uncommment the line below, remove the line above if you don't want the page control to loop.
               //return nil
        }
                  
        guard orderedViewControllers.count > previousIndex else
        {
            return nil
        }
          
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {return nil}
                
           let nextIndex = viewControllerIndex + 1
           let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
           guard orderedViewControllersCount != nextIndex else
           {
              return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
           }
           
        
           guard orderedViewControllersCount > nextIndex else
           {
            return nil
           }
        
           return orderedViewControllers[nextIndex]
    }
    func getVCIndex(vc: UIViewController)
    {
        if let viewControllerIndex = orderedViewControllers.firstIndex(of: vc)
        {
            //LibraryViewController.currentvcIndex = viewControllerIndex
            PVC.sharedInstance.currindex = viewControllerIndex
        }
        
        //guard let viewControllerIndex = orderedViewControllers.firstIndex(of: vc) else {return nil}
       
        
    }
    
    func goNextPage(position: Int)
    {
    
        let viewController = self.orderedViewControllers[position]
        
        DispatchQueue.main.async
        {
            self.setViewControllers([viewController], direction: .forward, animated: true)
        }

    }
    func addobservers()
    {
        for vc in self.children
        {
            //vc.addObserver(<#T##observer: NSObject##NSObject#>, forKeyPath: <#T##String#>, options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutableRawPointer?#>)
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        self.preferredContentSize = container.preferredContentSize
        
    }
    
    
}
