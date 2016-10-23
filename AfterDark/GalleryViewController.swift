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
    override func viewDidAppear(animated: Bool) {
        self.view.frame = CGRectMake(0, 44, 375, 300)
        self.pageViewController.setViewControllers([viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

    }
    func Initialize()
    {

       
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)


        let initialViewCont  = viewControllerAtIndex(0)
        pages.append(initialViewCont)
        self.pageViewController.setViewControllers(pages, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        
        let pc = UIPageControl.appearance()
        pc.pageIndicatorTintColor = UIColor.lightGrayColor()
        pc.currentPageIndicatorTintColor = UIColor.blackColor()
        pc.backgroundColor = UIColor.grayColor()
        self.pageViewController.view.backgroundColor = UIColor.whiteColor()
        

//        self.pageViewController.dataSource = nil;
//        self.pageViewController.delegate = nil;
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self;
        
        self.addChildViewController(self.pageViewController)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.view.addSubview(self.pageViewController.view)
    }
    
    
    func Load()
    {
        
        //this bar origin
        let thisBarOrigin = BarManager.singleton.displayedDetailBar
//        
        if thisBarOrigin.Images.count == 0
        {
            //get number of pages
            let thisBarFormatName = thisBarOrigin.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let urlNumberOfImages = "http://mooselliot.net23.net/GetNumberOfImages.php?Bar_Name=\(thisBarFormatName)"
            Network.singleton.StringFromUrl(urlNumberOfImages, handler: {(success,output) -> Void in
                let numberOfPages = Int(output!)
                
                if let numberOfPages = numberOfPages
                {
                    //reset pages
                    self.pages.removeAll()
                    
                    for index in 0...numberOfPages {
                        //for each page here, create a view controller
                        let pageCont = ContentViewController(frame: self.view.frame)
                        pageCont.pageIndex = index
                        self.pages.append(pageCont)
                        
                        
                        let thisBarFormatName = thisBarOrigin.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
                        let urlLoadImageAtIndex = "http://mooselliot.net23.net/GetBarGalleryImage.php?Bar_Name=\(thisBarFormatName)&Image_Index=\(index)"
                        Network.singleton.StringFromUrl(urlLoadImageAtIndex, handler: {(success,output)->Void in
                            if let output = output
                            {
                                if success == true
                                {
                                    let imageString = output
                                    let dataDecoded:NSData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                                    let image = UIImage(data: dataDecoded)
                                    
                                    if let image = image
                                    {
                                        thisBarOrigin.Images.append(image)
                                        
                                    }
                                    
                                    
                                    //ui update is done when view is about to present
                                }
                                
                                
                                
                            }
                            
                        })
                    }
                    
                    //update page control display
                    self.pageViewController.setViewControllers([self.pages[0]], direction: .Forward, animated: false, completion: nil)
                    
                    
                }
                
                //**********************
                //  no of pages loaded
                //*********************
                
                
            })

        }
        else
        {
            
        }
        
            }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as? ContentViewController
        guard var index = vc?.pageIndex else{
            return nil
        }
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as? ContentViewController
        guard var index = vc?.pageIndex else{
            return nil
        }
        if (index == self.pages.count - 1 || index == NSNotFound) {
            return nil
        }
        
        //prompt loading of image
        index++
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
    
    func viewControllerAtIndex(index: Int) ->ContentViewController {
        if (self.pages.count == 0) || (index >= self.pages.count) {
            return ContentViewController(frame: self.view.frame)
        }
        
        let vc = pages[index]
        vc.pageIndex = index
        if index >= 0 && index < BarManager.singleton.displayedDetailBar.Images.count
        {
            vc.imageView.image = BarManager.singleton.displayedDetailBar.Images[index]
        }
        return vc
    }

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    func changePage(direction : Int)
    {
        if direction == 0 //right swipe
        {
            if currentPageIndex > 0 && pages.count != 0
            {
                currentPageIndex = currentPageIndex - 1
                pageViewController.setViewControllers([viewControllerAtIndex(currentPageIndex)], direction: .Reverse, animated: true, completion: nil)
            }

        }
        else
        {
            if currentPageIndex < pages.count - 1
            {
                currentPageIndex = currentPageIndex + 1
                pageViewController.setViewControllers([viewControllerAtIndex(currentPageIndex)], direction: .Forward, animated: true, completion: nil)
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
        imageView.contentMode = .ScaleAspectFit
        self.view.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
