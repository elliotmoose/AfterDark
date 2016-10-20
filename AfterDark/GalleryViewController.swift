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
    
    var pages = [GalleryPageViewController]()
    var images = [UIImage]()
    var thisBar = Bar()
    var currentPage : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Initialize()
    {
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        let temp  = UIViewController(nibName: nil, bundle: nil)
        temp.view = UIView(frame: self.view.frame)
        let tempArr = [temp]
        self.pageViewController.setViewControllers(tempArr, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)


        let pc = UIPageControl.appearance()
        pc.pageIndicatorTintColor = UIColor.lightGrayColor()
        pc.currentPageIndicatorTintColor = UIColor.blackColor()
        pc.backgroundColor = UIColor.whiteColor()
        self.pageViewController.view.backgroundColor = UIColor.darkGrayColor()

        
       
        
        self.pageViewController.view.frame = self.view.frame

        self.pageViewController.dataSource = nil;
        self.pageViewController.delegate = nil;
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self;
        
        self.addChildViewController(self.pageViewController)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.view.addSubview(self.pageViewController.view)
    }
    
    func Load()
    {

//        
        //get number of pages
        let thisBarFormatName = thisBar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let urlNumberOfImages = "http://mooselliot.net23.net/GetNumberOfImages.php?Bar_Name=\(thisBarFormatName)"
        Network.singleton.StringFromUrl(urlNumberOfImages, handler: {(success,output) -> Void in
            let numberOfPages = Int(output!)

            if let numberOfPages = numberOfPages
            {
                //reset pages
                self.pages.removeAll()
                
                for index in 0...numberOfPages {
                    //for each page here, create a view controller
                    let pageCont = GalleryPageViewController(frame: self.view.frame)
                    
                    //test
                    if index == 1
                    {
                        pageCont.view.backgroundColor = UIColor.whiteColor()
                    }
                    
                    self.pages.append(pageCont)
                    
//                    
//                    let thisBarFormatName = self.thisBar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
//                    let urlLoadImageAtIndex = "http://mooselliot.net23.net/GetBarGalleryImage.php?Bar_Name=\(thisBarFormatName)&Image_Index=\(index)"
//                    Network.singleton.StringFromUrl(urlLoadImageAtIndex, handler: {(success,output)->Void in
//                        if let output = output
//                        {
//                            if success == true
//                            {
//                                let imageString = output
//                                let dataDecoded:NSData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
//                                let imageView = UIImageView(image: UIImage(data: dataDecoded))
//                                imageView.frame = self.view.frame
//                                imageView.contentMode = .ScaleAspectFit
//                                self.pages[index] = imageView
//                                self.pageViewController.view.addSubview(imageView)
//                            }
//                            
//                            
//                            
//                        }
//                        
//                    })
                }
                

            }
            
            //**********************
            //  no of pages loaded
            //*********************
            

        })
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {

        if (currentPage == 0 || currentPage == NSNotFound) {
            return nil
        }
        
        //prompt loading of image
        
        return viewControllerAtIndex(currentPage - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {

        if (currentPage == self.pages.count - 1 || currentPage == NSNotFound) {
            return nil
        }
        
        //prompt loading of image

        return viewControllerAtIndex(currentPage + 1)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func viewControllerAtIndex(index: Int) -> GalleryPageViewController {
        if (self.pages.count == 0) || (index >= self.pages.count) {
            return GalleryPageViewController(frame: self.view.frame)
        }
        let vc = pages[index]
        vc.pageIndex = index
        if index == currentPage
        {
            print(index)
        }
        return vc
    }

}

class GalleryPageViewController: UIViewController
{
    var pageIndex = -1
    var imageView = UIImageView()
    
    init(frame: CGRect)
    {
        super.init(nibName: nil, bundle: nil)
        self.view = UIView(frame: frame)
        imageView.frame = frame;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContentViewController: UIViewController
{
    var pageIndex: Int = -1
    var thisBar = Bar()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
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
