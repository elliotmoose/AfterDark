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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.view.frame = CGRectMake(0, 44, Sizing.ScreenWidth(), Sizing.HundredRelativeWidthPts()*3)
        if pages.count == 0
        {
            self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: .forward, animated: true, completion: nil)

        }
        else
        {
            self.pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)

        }

    }

    func ToPresentNewDetailBar()
    {
        //reset images
        pages.removeAll()
        currentPageIndex = 0
        //check if bar has pre loaded images
        let barOrigin = BarManager.singleton.displayedDetailBar
        if barOrigin.Images.count != 0 && barOrigin.Images.count > 0
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
        
        
        //update UI
self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }

    func Initialize()
    {

       
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        
        let pc = UIPageControl.appearance()
        pc.pageIndicatorTintColor = ColorManager.galleryPageControlDotNormalColor
        pc.currentPageIndicatorTintColor = ColorManager.galleryPageControlDotHighlightColor
        pc.backgroundColor = ColorManager.galleryPageControlBGColor
        self.pageViewController.view.backgroundColor = ColorManager.galleryBGColor
        

        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self;
        
        self.addChildViewController(self.pageViewController)
        self.pageViewController.didMove(toParentViewController: self)

        
        self.view.addSubview(self.pageViewController.view)
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
    
    func viewControllerAtIndex(_ index: Int) ->ContentViewController {
        if (self.pages.count == 0) || (index >= self.pages.count) {
            let vc = ContentViewController(frame: self.view.frame)
            vc.pageIndex = index
            
            if index >= 0 && index < BarManager.singleton.displayedDetailBar.Images.count
            {
                vc.imageView.image = BarManager.singleton.displayedDetailBar.Images[index]
            }
            
            return vc
        }
        
        let vc = pages[index]
        vc.pageIndex = index
        if index >= 0 && index < BarManager.singleton.displayedDetailBar.Images.count
        {
            vc.imageView.image = BarManager.singleton.displayedDetailBar.Images[index]
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
}

//class GalleryPageViewController: UIViewController
//{
//    var pageIndex = -1
//    var imageView = UIImageView()
//    
//    init(frame: CGRect)
//    {
//        super.init(nibName: nil, bundle: nil)
//        self.view = UIView(frame: frame)
//        imageView.frame = frame;
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class ContentViewController: UIViewController
{
    var pageIndex: Int = -1
    var thisBar = Bar()
    var imageView = UIImageView()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        


        
    }
    
    
    init(frame: CGRect)
    {
        super.init(nibName: nil, bundle: nil)
        self.view = UIView(frame: frame)
        imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
