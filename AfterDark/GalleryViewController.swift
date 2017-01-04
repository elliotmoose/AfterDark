//
//  GalleryViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 19/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIGestureRecognizerDelegate {
    static let singleton = GalleryViewController()
    var pageViewController = UIPageViewController()
    var pages = [ContentViewController]()
    
    var images = [UIImage]()
    
    var currentPageIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        //self.view.frame = CGRect(x: 0, y: Sizing.tabHeight, width: Sizing.ScreenWidth(), height: Sizing.galleryHeight)
//        if pages.count == 0
//        {
//            self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: .forward, animated: false, completion: nil)
//
//        }
//        else
//        {
//            self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: .forward, animated: false, completion: nil)
//
//        }

    }

    func ToPresentNewDetailBar()
    {
        //reset images
        pages.removeAll()
        currentPageIndex = 0
        //check if bar has pre loaded images
        guard let barOrigin = BarManager.singleton.displayedDetailBar else {return}
        if barOrigin.Images.count > 0 && barOrigin.maxImageCount > 0
        {
            //then load from memory 
            
            //first load number of images
            for index in 0...barOrigin.maxImageCount - 1
            {
                pages.append(viewControllerAtIndex(index))
            }
        }
        else if barOrigin.maxImageCount == -1
        {
            GalleryManager.singleton.LoadMaxPages(barOrigin, handler:
            {
                (success) -> Void in
                
                if success
                {
                    if barOrigin.maxImageCount == 0
                    {
                        return
                    }
                    self.pages.removeAll()
                    for index in 0...barOrigin.maxImageCount - 1
                    {
                        self.pages.append(self.viewControllerAtIndex(index))
                    }
                    self.pageViewController.setViewControllers([self.viewControllerAtIndex(0)], direction: .forward, animated: false, completion: nil)
                    
                    
                    GalleryManager.singleton.LoadBarGallery(barOrigin,handler:
                    {
                        (success) -> Void in
                        if success
                        {
                            self.pageViewController.setViewControllers([self.viewControllerAtIndex(self.currentPageIndex)], direction: .forward, animated: false, completion: nil)
                        }
                            
                    })
                }
                
            })
        }
        
        
//        //update UI
        self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }

    func Initialize(frame : CGRect)
    {

       
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.view.frame = frame
        
        self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        
        
//        let pc = UIPageControl.appearance()
//        pc.pageIndicatorTintColor = ColorManager.galleryPageControlDotNormalColor
//        pc.currentPageIndicatorTintColor = ColorManager.galleryPageControlDotHighlightColor
//        pc.backgroundColor = ColorManager.galleryPageControlBGColor

        
        self.pageViewController.view.backgroundColor = ColorManager.galleryBGColor
        

        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self;
        
        self.addChildViewController(self.pageViewController)
        self.pageViewController.didMove(toParentViewController: self)

        
        self.view.addSubview(self.pageViewController.view)
        self.view.clipsToBounds = true
        

    }
    
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as? ContentViewController
        guard var index = vc?.pageIndex else{
            return nil
        }
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as? ContentViewController
        guard var index = vc?.pageIndex else{
            return nil
        }
        if (index == self.pages.count - 1 || index == NSNotFound) {
            return nil
        }
        
        //prompt loading of image
        index += 1
        return viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
    
    //***************************************************************************************
    //                                      VIEW CONTROLLER
    //***************************************************************************************

    func viewControllerAtIndex(_ index: Int) ->ContentViewController {
        guard let bar = BarManager.singleton.displayedDetailBar else {return ContentViewController(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.galleryHeight))}
        
        if (self.pages.count == 0) || (index >= self.pages.count) {
            let vc = ContentViewController(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.galleryHeight))
            
            vc.pageIndex = index
            
            if index >= 0 && index < bar.Images.count
            {
                vc.imageView.image = bar.Images[index]
            }
            
            return vc
        }
        
        let vc = pages[index]
        vc.pageIndex = index
        if index >= 0 && index < bar.Images.count
        {
            vc.imageView.image = bar.Images[index]
        }
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    func changePage(_ direction : Int)
    {
        if direction == 0 //right swipe
        {
            if currentPageIndex > 0 && pages.count != 0
            {
                currentPageIndex = currentPageIndex - 1
                pageViewController.setViewControllers([viewControllerAtIndex(currentPageIndex)], direction: .reverse, animated: true, completion: nil)
            }

        }
        else
        {
            if currentPageIndex < pages.count - 1
            {
                currentPageIndex = currentPageIndex + 1
                pageViewController.setViewControllers([viewControllerAtIndex(currentPageIndex)], direction: .forward, animated: true, completion: nil)
            }
            

        }
        
    }
    
    func UpdateFrameDuringScroll()
    {
        
        for page in pages
        {
            page.imageView.frame = self.view.frame
        }
        viewControllerAtIndex(currentPageIndex).imageView.frame = self.view.frame
    }
}



class ContentViewController: UIViewController
{
    var pageIndex: Int = -1
    var imageView = UIImageView()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
    }
    
    
    init(frame: CGRect)
    {
        super.init(nibName: nil, bundle: nil)
        self.view = UIView(frame: frame)
        self.view.backgroundColor = UIColor.clear
        imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        self.view.clipsToBounds = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
