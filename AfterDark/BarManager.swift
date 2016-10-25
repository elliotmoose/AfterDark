import Foundation
import UIKit
protocol BarManagerToListTableDelegate :class
{
    func UpdateBarListTableDisplay()
    func UpdateCellForBar(bar : Bar)



}
protocol BarManagerToDetailTableDelegate :class
{

    func UpdateDescriptionTab()
    
    
}
class BarManager: NSObject
{
    static let singleton = BarManager()
    //constants
    let urlAllBarNames = "http://mooselliot.net23.net/GetAllBarNames.php"
    let urlBarIconImage = "http://mooselliot.net23.net/GetBarIconImage.php"
    
    
    
    //variables
    var mainBarList: [Bar] = []
    var displayBarList: [[Bar]] = [[]]
    var barListIcons: [NSDictionary] = []
    var displayedDetailBar = Bar()
    weak var detailDelegate:BarManagerToDetailTableDelegate?
    weak var listDelegate :BarManagerToListTableDelegate?
    
    //methods
    private override init()
    {
        displayedDetailBar.name = "display Bar"
        displayedDetailBar.description = "description"
    }
    
    func DisplayBarDetails(bar : Bar)
    {
        //passing by value
//        displayedDetailBar.name = bar.name
//        displayedDetailBar.icon = bar.icon
//        displayedDetailBar.description = bar.description
//        displayedDetailBar.Images = bar.Images
//        displayedDetailBar.rating = bar.rating
//        displayedDetailBar.loc_lat = bar.loc_lat
//        displayedDetailBar.loc_long = bar.loc_long
        //passing by reference
        displayedDetailBar = bar
        
        //start loading reviews
        
    }
    func LoadGenericBarData(handler: ()-> Void)//consits of 2 key details: name, ratings , however, we do not wanna overwrite already loaded details (e.g. icon,description)
    {
        //Load All Bar Names
        Network.singleton.DataFromUrl(urlAllBarNames,handler: {(success,output) -> Void in
            if success == true
            {
                if let output = output
                {
                    let tempMainBarList = self.BarListGenericDataToArray(output)
                    
                    //If list has never been loaded
                    if self.mainBarList.count == 0
                    {
                        self.mainBarList = tempMainBarList
                    }
                    else
                    {
                        let cache = self.mainBarList
                        var allOldBarNames = [String]()
                        for oldBar in cache
                        {
                            allOldBarNames.append(oldBar.name)
                        }
                        
                        self.mainBarList = tempMainBarList
                        for newBar in self.mainBarList
                        {
                            let indexInCache = allOldBarNames.indexOf(newBar.name)
                            let oldBar = cache[indexInCache!]
                            
                            if oldBar.icon != nil
                            {
                                newBar.icon = oldBar.icon
                            }
                            
                            if oldBar.Images.count != 0
                            {
                                newBar.Images = oldBar.Images
                            }
                        }
                        
                        
                    }
                }
                
                //callback to update UI before continue loading images
                self.listDelegate?.UpdateBarListTableDisplay()
                
                self.LoadAllBarIcons()
            }
            handler()
        });
    }
    
    
    func LoadAllNonImageDetailBarData(handler: () -> Void)
    {
        for bar in mainBarList
        {
            let thisBarFormattedName = bar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let urlNonImageBarInfo = "http://mooselliot.net23.net/GetBarNonImageInfo.php?Bar_Name=\(thisBarFormattedName)"
            Network.singleton.DictArrayFromUrl(urlNonImageBarInfo, handler: {(success,output) -> Void in
                if success
                {
                    if output.count != 0
                    {
                        let dict = output[0]
                        
                        bar.description = dict["Bar_Description"] as! String
                        bar.contact = dict["Bar_Contact"] as! String
                        bar.openClosingHours = dict["Bar_OpeningClosingHours"] as? String
                        bar.loc_lat = Float(dict["Bar_Location_Latitude"] as! String)!
                        bar.loc_long = Float(dict["Bar_Location_Longitude"] as! String)!
                    
                        
                        if self.displayedDetailBar.name == bar.name
                        {
                            self.detailDelegate?.UpdateDescriptionTab()
                        }
                        
                        handler()
                    }
                }
            })
            

        }

    }
    
    func LoadGalleryImageData(handler: () -> Void)
    {
        
    }
    
    
    func LoadAllBarIcons()
    {
        for bar in mainBarList
        {
            if bar.icon == nil
            {
                let barNameForUrl = bar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
                let requestUrl = "http://mooselliot.net23.net/GetBarIconImage.php?Bar_Name=\(barNameForUrl)"
                Network.singleton.StringFromUrl(requestUrl, handler: {(success,output)-> Void in
                    
                    if success
                    {
                        if let output = output
                        {
                            let imageString = output
                            let dataDecoded:NSData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                            bar.icon = UIImage(data: dataDecoded)

                            //update UI for that bar

                            self.listDelegate?.UpdateCellForBar(bar)
                        }
                    }
                    
                    })
            }
        }
    }
    //different data handlers
    func BarListGenericDataToArray(data:NSData) -> [Bar]
    {
        
        
        let retrievedArray = self.JSONToArray(data.mutableCopy() as! NSMutableData)
        var tempBarList = [Bar]()
        
        if retrievedArray.count == 0
        {return tempBarList}
        for index in 0...(retrievedArray.count - 1)
        {
            let dict = retrievedArray[index] as! NSDictionary
            tempBarList.append(self.NewBarFromDict(dict))
        }
        
        return tempBarList
    }
    
//    func BarIconsDataToArray(data:NSData) ->
//    {
//        let retrievedArray = self.JSONToArray(data.mutableCopy() as! NSMutableData)
//
//        var dictArray = [NSDictionary]()
//        for index in 0...(retrievedArray.count - 1)
//        {
//            let barDict = retrievedArray[index] as! NSDictionary
//            dictArray.append(barDict)
//        }
//        
//        //inject icons into data array
//        for index in 0...(mainBarList.count-1)
//        {
//            let thisBar = mainBarList[index]
//            for i in 0...(barListIcons.count-1)
//            {
//                if barListIcons[i].valueForKey("Bar_Name") as? String == thisBar.name
//                {
//                    let base64Image = barListIcons[i].valueForKey("Bar_Icon") as? String
//                    if let base64Image = base64Image
//                    {
//                        let dataDecoded:NSData = NSData(base64EncodedString: base64Image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
//                        thisBar.icon = UIImage(data: dataDecoded)
//                    }
//                    
//                }
//            }
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    func NewBarFromDict(dict: NSDictionary) ->Bar
    {
        let newBar = Bar()
        newBar.name = dict.valueForKey("Bar_Name") as! String
        newBar.ID = dict.valueForKey("Bar_ID") as! String
        newBar.rating.InjectValues(Float(dict.valueForKey("Bar_Rating_Avg") as! String)!, pricex: Float(dict.valueForKey("Bar_Rating_Price") as! String)!, ambiencex: Float(dict.valueForKey("Bar_Rating_Ambience") as! String)!,foodx: Float(dict.valueForKey("Bar_Rating_Food") as! String)!, servicex: Float(dict.valueForKey("Bar_Rating_Service") as! String)!)
        
        return newBar
    }
    
    func ArrangeBarList(mode: DisplayBarListMode)
    {
        
        //reset output
        displayBarList.removeAll()
        
        switch mode
        {
        case .alphabetical:
            
            
            //create array of all letters
            var allFirstLetters = [Character]()
            for bar in mainBarList
            {
                let firstLetter = bar.name.characters.first
                //if does not contain first letter add it
                if let firstLetter = firstLetter
                {
                    if !allFirstLetters.contains(firstLetter)
                    {
                        allFirstLetters.append(firstLetter)
                    }
                }
                
            }
            
            //for each letter
            for firstLetter in allFirstLetters
            {
                //create array
                var arrayOfBarsForLetter = [Bar]()
                
                //for each bar
                for bar in mainBarList
                {
                    //if has this first letter, add to array
                    if bar.name.characters.first == firstLetter
                    {
                        arrayOfBarsForLetter.append(bar)
                    }
                }
                
                
                //arrange alphabetically within array
                arrayOfBarsForLetter.sortInPlace({$0.name < $1.name})
                
                
                //add array to collection of arrays of letter-arranged bars
                
                displayBarList.append(arrayOfBarsForLetter)
            }
            
            
            break
            
        case .avgRating:
            
            var singleArray = mainBarList
            singleArray.sortInPlace({$0.rating.avg < $1.rating.avg})
            displayBarList.append(singleArray)
            break;
        case .priceRating:
            var singleArray = mainBarList
            singleArray.sortInPlace({$0.rating.price < $1.rating.price})
            displayBarList.append(singleArray)
            break;
        case .foodRating:
            var singleArray = mainBarList
            singleArray.sortInPlace({$0.rating.food < $1.rating.food})
            displayBarList.append(singleArray)
            break;
        case .ambienceRating:
            var singleArray = mainBarList
            singleArray.sortInPlace({$0.rating.ambience < $1.rating.ambience})
            displayBarList.append(singleArray)
            break;
        case .serviceRating:
            var singleArray = mainBarList
            singleArray.sortInPlace({$0.rating.service < $1.rating.service})
            displayBarList.append(singleArray)
            break;
            
        }
        
    }
    
    func JSONToArray(data : NSMutableData) -> NSMutableArray{
        
        var output: NSMutableArray = NSMutableArray()
        
        do{
            
            output = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
            
            
        } catch let error as NSError {
            print(error)
            
        }
        
        return output
        
    }
    
    func JsonDataToDictArray(data: NSMutableData) -> [NSDictionary]
    {
        var output = [NSDictionary]()
        var tempArr: NSMutableArray = NSMutableArray()
        
        do{
            
            tempArr = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
            
            for index in 0...(tempArr.count - 1)
            {
                let dict = tempArr[index] as! NSDictionary
                output.append(dict)
            }
            
        } catch let error as NSError {
            print(error)
            
        }
        
        return output
    }
    
}
