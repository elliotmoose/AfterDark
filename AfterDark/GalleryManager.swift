class GalleryManager
{
    static let singleton = GalleryManager()
    
    func init()
    {
        
    }

    func LoadMaxPages(thisBarOrigin: Bar, handler: (success: Bool)-> Void)
    {
        
    }

    func LoadBarGallery(thisBarOrigin: Bar,handler: (success: Bool)-> Void)
    {
        
          if thisBarOrigin.Images.count == 0
        {
            //get number of pages
            let thisBarFormatName = thisBarOrigin.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let urlNumberOfImages = "http://mooselliot.net23.net/GetNumberOfImages.php?Bar_Name=\(thisBarFormatName)"
            Network.singleton.StringFromUrl(urlNumberOfImages, handler: {(success,output) -> Void in
                let numberOfPages = Int(output!)
                
                if let numberOfPages = numberOfPages
                {
                    //set max number
                    thisBarOrigin.maxImagesCount = numberOfPages
                    
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
                
                //**********************//
                //  no of pages loaded
                //*********************//
                
                
            })

        }
        else
        {
            
        }
        
            }

    }
}