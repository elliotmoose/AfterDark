import Foundation
import UIKit
protocol BarManagerToListTableDelegate :class
{
    func UpdateBarListTableDisplay()
    func UpdateCellForBar(_ bar : Bar)



}
protocol BarManagerToDetailTableDelegate :class
{

    func UpdateDescriptionTab()
    
    
}
class BarManager: NSObject
{
    static let singleton = BarManager()
    //constants
    let urlAllBarNames = Network.domain + "GetAllBarNames.php"
    let urlBarIconImage = Network.domain + "GetBarIconImage.php"
    
    
    
    //variables
    var mainBarList: [Bar] = []
    var displayBarList: [[Bar]] = [[]]
    var barListIcons: [NSDictionary] = []
    var displayedDetailBar = Bar()
    weak var detailDelegate:BarManagerToDetailTableDelegate?
    weak var listDelegate :BarManagerToListTableDelegate?
    
    //methods
    fileprivate override init()
    {
        displayedDetailBar.name = "display Bar"
        displayedDetailBar.description = "description"
    }
    
    func DisplayBarDetails(_ bar : Bar)
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
    func LoadGenericBarData(_ handler: @escaping ()-> Void)//consits of 2 key details: name, ratings , however, we do not wanna overwrite already loaded details (e.g. icon,description)
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
                        //stores the old list (for future comparison)
                        let cache = self.mainBarList
                        var allOldBarNames = [String]()
                        
                        //gets all the names of the old bar
                        for oldBar in cache
                        {
                            allOldBarNames.append(oldBar.name)
                        }
                        
                        //get the new bar list
                        self.mainBarList = tempMainBarList
                        
                        //start comparions
                        for newBar in self.mainBarList//for each bar in new list
                        {
                            //if the old bar list contains this new bar
                            if allOldBarNames.contains(newBar.name)
                            {
                                let indexInCache = allOldBarNames.index(of: newBar.name)
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
                }
                

                
                //callback to update UI before continue loading images
                self.listDelegate?.UpdateBarListTableDisplay()
                
                self.LoadAllBarIcons()
            }
            

            handler()
        });
        
        //***testing only***
        if Settings.modelBarActive
        {
            self.LoadModelBar()
            
            
            //callback to update UI before continue loading images
            self.listDelegate?.UpdateBarListTableDisplay()
        }


    }
    
    
    func LoadAllNonImageDetailBarData(_ handler: @escaping () -> Void)
    {
        for bar in mainBarList
        {
            let thisBarFormattedName = bar.name.replacingOccurrences(of: " ", with: "+")
            let urlNonImageBarInfo = Network.domain + "GetBarNonImageInfo.php?Bar_Name=\(thisBarFormattedName)"
            Network.singleton.DictArrayFromUrl(urlNonImageBarInfo, handler: {(success,output) -> Void in
                if success
                {
                    if output.count != 0
                    {
                        let dict = output[0]
                        
                        bar.description = dict["Bar_Description"] as! String
                        bar.contact = dict["Bar_Contact"] as! String

                        //get opening hours
                        if let monday = dict["OH_Monday"] as? String
                        {
                            bar.openClosingHours[0] = monday
                        }
                        
                        if let tuesday = dict["OH_Tuesday"] as? String
                        {
                            bar.openClosingHours[1] = tuesday
                        }
                        
                        if let wednesday = dict["OH_Wednesday"] as? String
                        {
                            bar.openClosingHours[2] = wednesday
                        }
                        
                        if let thursday = dict["OH_Thursday"] as? String
                        {
                            bar.openClosingHours[3] = thursday
                        }
                        
                        if let friday = dict["OH_Friday"] as? String
                        {
                            bar.openClosingHours[4] = friday
                        }
                        
                        if let saturday = dict["OH_Saturday"] as? String
                        {
                            bar.openClosingHours[5] = saturday
                        }
                        
                        if let sunday = dict["OH_Sunday"] as? String
                        {
                            bar.openClosingHours[6] = sunday
                        }
                        
                        
                        bar.loc_lat = Float(dict["Bar_Location_Latitude"] as! String)!
                        bar.loc_long = Float(dict["Bar_Location_Longitude"] as! String)!
                        bar.bookingAvailable = dict.value(forKey: "Booking_Available") as! String

                        
                        if self.displayedDetailBar.name == bar.name
                        {
                            self.detailDelegate?.UpdateDescriptionTab()
                        }
                        
                        handler()
                        
                        DispatchQueue.main.async {
                            self.detailDelegate?.UpdateDescriptionTab()
                        }
                    }
                }
            })
            

        }

    }
    
    func LoadGalleryImageData(_ handler: () -> Void)
    {
        
    }
    
    
    func LoadAllBarIcons()
    {
        for bar in mainBarList
        {
            if bar.icon == nil
            {
                let barNameForUrl = bar.name.replacingOccurrences(of: " ", with: "+")
                let requestUrl = Network.domain + "GetBarIconImage.php?Bar_Name=\(barNameForUrl)"
                Network.singleton.StringFromUrl(requestUrl, handler: {(success,output)-> Void in
                    
                    if success
                    {
                        if let output = output
                        {
                            let imageString = output
                            let dataDecoded:Data = Data(base64Encoded: imageString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                            bar.icon = UIImage(data: dataDecoded)

                            //update UI for that bar at bar list view controller

                            self.listDelegate?.UpdateCellForBar(bar)
                        }
                    }
                    
                    })
            }
        }
    }
    //different data handlers
    func BarListGenericDataToArray(_ data:Data) -> [Bar]
    {
        
        
        let retrievedArray = self.JSONToArray((data as NSData).mutableCopy() as! NSMutableData)
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
    
    
    func LoadModelBar()
    {
        let modelBar = Bar()
        modelBar.name = "Model Bar"
        modelBar.bookingAvailable = "1"
        modelBar.contact = "91839283"
        modelBar.description = "This is a model Bar used for testing purposes. It can be used for offline viewing and debugging"
        modelBar.icon = #imageLiteral(resourceName: "AfterDarkIcon")
        modelBar.openClosingHours[0] = "2pm - 12am daily"
        
        var newRating = Rating()
        newRating.InjectValues(4, pricex: 3, ambiencex: 3, foodx: 5, servicex: 5)
        let newReview = Review(rating: newRating, ID: "2", title: "Great Bar", description: "Amazing food and wonderful service", user_name: "mooselliot", date: NSDate(timeIntervalSinceNow: 0) as Date)
        
        modelBar.reviews.append(newReview)
        mainBarList.append(modelBar)
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
    
    
    
    
    
    
    func BarFromBarID(_ barID : String) -> Bar?
    {
        for bar in self.mainBarList
        {
            if bar.ID == barID
            {
                return bar
            }
        }
        
        return nil
    }
    
    
    
    func NewBarFromDict(_ dict: NSDictionary) ->Bar
    {
        let newBar = Bar()
        newBar.name = dict.value(forKey: "Bar_Name") as! String
        newBar.ID = String(describing: (dict.value(forKey: "Bar_ID") as? Int)!)
        
        let ratingAvg = dict.value(forKey: "Bar_Rating_Avg") as! Float
        let ratingPrice = dict.value(forKey: "Bar_Rating_Price") as! Float
        let ratingAmbience = dict.value(forKey: "Bar_Rating_Ambience") as! Float
        let ratingFood = dict.value(forKey: "Bar_Rating_Food") as! Float
        let ratingService = dict.value(forKey: "Bar_Rating_Service") as! Float
        
        
        newBar.rating.InjectValues(ratingAvg, pricex: ratingPrice, ambiencex:ratingAmbience,foodx: ratingFood, servicex: ratingService)
        
        return newBar
    }
    
    func ArrangeBarList(_ mode: DisplayBarListMode)
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
                arrayOfBarsForLetter.sort(by: {$0.name < $1.name})
                
                
                //add array to collection of arrays of letter-arranged bars
                
                displayBarList.append(arrayOfBarsForLetter)
            }
            
            
            break
            
        case .avgRating:
            
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.avg < $1.rating.avg})
            displayBarList.append(singleArray)
            break;
        case .priceRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.price < $1.rating.price})
            displayBarList.append(singleArray)
            break;
        case .foodRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.food < $1.rating.food})
            displayBarList.append(singleArray)
            break;
        case .ambienceRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.ambience < $1.rating.ambience})
            displayBarList.append(singleArray)
            break;
        case .serviceRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.service < $1.rating.service})
            displayBarList.append(singleArray)
            break;
            
        }
        
    }
    
    func JSONToArray(_ data : NSMutableData) -> NSMutableArray{
        
        var output: NSMutableArray = NSMutableArray()
        
        do{
            
            let array = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! Array<Any>
            output = NSMutableArray(array: array)
            
            
        } catch let error as NSError {
            print(error)
            
        }
        
        return output
        
    }
    
    func JsonDataToDictArray(_ data: NSMutableData) -> [NSDictionary]
    {
        var output = [NSDictionary]()
        var tempArr: NSMutableArray = NSMutableArray()
        
        do{
            
            let array = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! Array<Any>
            tempArr = NSMutableArray(array: array)
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
