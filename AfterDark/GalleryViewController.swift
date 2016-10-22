//
//  GalleryViewController.swift
//  AfterDark
//
//  Created by Swee Har Ng on 19/10/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    static let singleton = GalleryViewController()
    var pageViewController = UIPageViewController()
    
    var pages = [UIImage]()
    var allPageViewControllers = [ContentViewController]()
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
    }
    func Initialize()
    {


        for _ in 0...5
        {
            let image = UIImage()
            pages.append(image)
            
        }
       
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)


        let initialViewCont  = viewControllerAtIndex(0)
        allPageViewControllers.append(initialViewCont)
        self.pageViewController.setViewControllers(allPageViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        
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
    
//    func Load()
//    {
//
////        
//        //get number of pages
//        let thisBarFormatName = ""//BarManager.singleton.selectedBarForDetailView!.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
//        let urlNumberOfImages = "http://mooselliot.net23.net/GetNumberOfImages.php?Bar_Name=\(thisBarFormatName)"
//        Network.singleton.StringFromUrl(urlNumberOfImages, handler: {(success,output) -> Void in
//            let numberOfPages = Int(output!)
//
//            if let numberOfPages = numberOfPages
//            {
//                //reset pages
//                self.pages.removeAll()
//                
//                for index in 0...numberOfPages {
//                    //for each page here, create a view controller
//                    let pageCont = GalleryPageViewController(frame: self.view.frame)
//                    
//                    //test
//                    if index == 1
//                    {
//                        pageCont.view.backgroundColor = UIColor.whiteColor()
//                    }
//                    
//                    self.pages.append(pageCont)
//                    
////                    
////                    let thisBarFormatName = self.thisBar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
////                    let urlLoadImageAtIndex = "http://mooselliot.net23.net/GetBarGalleryImage.php?Bar_Name=\(thisBarFormatName)&Image_Index=\(index)"
////                    Network.singleton.StringFromUrl(urlLoadImageAtIndex, handler: {(success,output)->Void in
////                        if let output = output
////                        {
////                            if success == true
////                            {
////                                let imageString = output
////                                let dataDecoded:NSData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
////                                let imageView = UIImageView(image: UIImage(data: dataDecoded))
////                                imageView.frame = self.view.frame
////                                imageView.contentMode = .ScaleAspectFit
////                                self.pages[index] = imageView
////                                self.pageViewController.view.addSubview(imageView)
////                            }
////                            
////                            
////                            
////                        }
////                        
////                    })
//                }
//                
//
//            }
//            
//            //**********************
//            //  no of pages loaded
//            //*********************
//            
//
//        })
//    }

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
        return 0
    }
    
    func viewControllerAtIndex(index: Int) ->ContentViewController {
        if (self.pages.count == 0) || (index >= self.pages.count) {
            return ContentViewController()
        }
        
        let vc = ContentViewController()
        vc.pageIndex = index
        vc.view.backgroundColor = UIColor.blackColor()
        return vc
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
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if pageIndex > -1
        {
            let thisBarFormatName = thisBar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let urlLoadImageAtIndex = "http://mooselliot.net23.net/GetBarGalleryImage.php?Bar_Name=\(thisBarFormatName)&Image_Index=\(pageIndex)"
            Network.singleton.StringFromUrl(urlLoadImageAtIndex, handler: {(success,output)->Void in
                if let output = output
                {
                    if success == true
                    {
                        let imageString = output
                        let dataDecoded:NSData? = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        if let dataDecoded = dataDecoded
                        {
                            let imageView = UIImageView(image: UIImage(data: dataDecoded))
                            imageView.contentMode = .ScaleAspectFit
                            self.view.addSubview(imageView)
                        }

                    }
                    
                    
                    
                }

            })
        }

        
    }
}
