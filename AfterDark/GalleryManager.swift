import Foundation
import UIKit
class GalleryManager
{
    static let singleton = GalleryManager()
    
    init()
    {
        
    }

    func LoadMaxPages(thisBarOrigin: Bar, handler: (success: Bool)-> Void)
    {
        //get number of pages
        let thisBarFormatName = thisBarOrigin.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let urlNumberOfImages = "http://mooselliot.net23.net/GetNumberOfImages.php?Bar_Name=\(thisBarFormatName)"
        Network.singleton.StringFromUrl(urlNumberOfImages, handler: {(success,output) -> Void in
            let noOfImages = Int(output!)
            if let noOfImages = noOfImages
            {
                //set max number
                thisBarOrigin.maxImageCount = noOfImages
                handler(success: true)
            }
        })
    }

    func LoadBarGallery(thisBarOrigin: Bar, handler: (success :Bool) -> Void)
    {
                    //reset pages
                    if thisBarOrigin.maxImageCount == -1
                    {return}
                    for index in 0...thisBarOrigin.maxImageCount
                    {
        
                        let thisBarFormatName = thisBarOrigin.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
                        let urlLoadImageAtIndex = "http://mooselliot.net23.net/GetBarGalleryImage.php?Bar_Name=\(thisBarFormatName)&Image_Index=\(index)"
                        Network.singleton.StringFromUrl(urlLoadImageAtIndex, handler:
                        {
                                (success,output)->Void in
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
                                            
                                            //update UI at page:
                                            handler(success: true)
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                        })
        }
    }
   


    }
