import Foundation
import UIKit
class GalleryManager
{
    static let singleton = GalleryManager()
    
    init()
    {
        
    }

    func LoadMaxPages(_ thisBarOrigin: Bar, handler: @escaping (_ success: Bool)-> Void)
    {
        //get number of pages
        let urlNumberOfImages = Network.domain + "GetNumberOfImages.php?Bar_ID=\(thisBarOrigin.ID)"
        Network.singleton.StringFromUrl(urlNumberOfImages, handler: {(success,output) -> Void in
            if success
            {
                if let output = output
                {
                    if let noOfImages = Int(output)
                    {
                        //set max number
                        thisBarOrigin.maxImageCount = noOfImages
                        handler(true)
                    }
                }
                else
                {
                    NSLog("No response from server")
                }
            }
            else
            {
                NSLog("No internet connection")
            }

        })
    }

//    func LoadBarGallery(_ thisBarOrigin: Bar, handler: @escaping (_ success :Bool) -> Void)
//    {
//        //reset pages
//        if thisBarOrigin.maxImageCount == 0
//        {return}
//        for index in 0...thisBarOrigin.maxImageCount
//        {
//            
//            let ID = thisBarOrigin.ID
//            let i = index;
//            let urlLoadImageAtIndex = Network.domain + "GetBarGalleryImage.php?Bar_ID=\(ID)&Image_Index=\(i)"
//            Network.singleton.StringFromUrl(urlLoadImageAtIndex, handler:
//                {
//                    (success,output)->Void in
//                    if let output = output
//                    {
//                        
//                        guard output != "nil" else {return}
//                        
//                        if success == true
//                        {
//                            let imageString = output
//                            let dataDecoded:Data = Data(base64Encoded: imageString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
//                            let image = UIImage(data: dataDecoded)
//                            
//                            if let image = image
//                            {
//                                thisBarOrigin.Images.append(image)
//                                
//                                //update UI at page:
//                                DispatchQueue.main.async
//                                {
//                                    //this is for discounts page
//                                    if let currentDisc = DiscountDetailViewController.singleton.currentDiscount
//                                    {
//                                        if thisBarOrigin.Images.count == 1 && currentDisc.bar_ID == thisBarOrigin.ID
//                                        {
//                                            DiscountDetailViewController.singleton.UpdateImage(image : image)
//                                        }
//                                    }
//                                    
//                                    
//                                    
//                                    
//                                    handler(true)
//                                }
//
//                            }
//                            
//                            
//                        }
//                        
//                    }
//                    
//            })
//        }
//    }
   
    
    
    func LoadBarGallery(_ thisBarOrigin: Bar, handler: @escaping (_ success :Bool) -> Void)
    {
        //reset pages
        if thisBarOrigin.maxImageCount == 0
        {return}
        for index in 0...thisBarOrigin.maxImageCount-1
        {
            
            let ID = thisBarOrigin.ID
            let i = index;
            let urlLoadImageAtIndex = Network.domain + "GetBarGalleryImage.php?Bar_ID=\(ID)&Image_Index=\(i)"
            //let urlLoadImageAtIndex = "http://localhost/AfterDarkServer/Bar_Images/0/Category_Classy.jpg"
            //let urlLoadImageAtIndex = Network.domain + "Bar_Images/\(ID)/\(index).jpg"
            Network.singleton.DataFromUrl(urlLoadImageAtIndex, handler:
                {
                    (success,output)->Void in
                    
                    if success == true
                    {
                        if let output = output
                        {
                            
                            if let image = UIImage(data: output)
                            {
                                
                                //update UI at page:
                                DispatchQueue.main.async
                                    {
                                        thisBarOrigin.Images.append(image) //CRASHED HERE
                                        handler(true)
                                }
                                
                            }
                            else
                            {
                                NSLog("invalid image format")
                                
                                let stringout = String(data: output, encoding: .utf8)!
                                NSLog(stringout)
                            }
                            
                            
                        }
                        else
                        {
                            NSLog("no image found")
                        }
                    }
                    else
                    {
                        NSLog("Cant connect, check connection")
                    }
            })
        }
    }
    
    
    
}
