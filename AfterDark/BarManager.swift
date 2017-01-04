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
    var displayedDetailBar : Bar? = nil
    weak var detailDelegate:BarManagerToDetailTableDelegate?
    weak var listDelegate :BarManagerToListTableDelegate?
    
    
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
    
    //====================================================================================
    //                                  BAR NAMES AND ICONS
    //====================================================================================
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
    
    //====================================================================================
    //                                  LOAD BAR DETAILS
    //====================================================================================
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
                        
               
                        let barDetails = self.NewBarFromDict(dict)
                        bar.bookingAvailable = barDetails.bookingAvailable
                        bar.description = barDetails.description
                        bar.openClosingHours = barDetails.openClosingHours
                        bar.loc_lat = barDetails.loc_lat
                        bar.loc_long = barDetails.loc_long
                        bar.address = barDetails.address
                        bar.contact = barDetails.contact
                        bar.website = barDetails.website

                        
                        if self.displayedDetailBar != nil && self.displayedDetailBar?.name == bar.name
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
    
    
    //====================================================================================
    //                                  BAR ICONS
    //====================================================================================
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
    //====================================================================================
    //                                  RELOAD BAR
    //====================================================================================
    func ReloadBar(ID : String, handler: @escaping (_ success : Bool,_ error :String, _ bar : Bar) -> Void)
    {
        let url = Network.domain + "ReloadBarData.php?Bar_ID=\(ID)"
        //generic data -> reviews discounts -> gallery
        
        Network.singleton.DataFromUrl(url, handler: {
            (success,output) -> Void in
            if success
            {
                if let output = output
                {
                    do
                    {
                        let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as! NSDictionary
                        
                        
                        guard let success = dict["success"] as? String else {return}
                        
                        if success == "true"
                        {
                            //then detail is another dict
                            if let detailDict = dict["detail"] as? NSDictionary
                            {
                                handler(true,"",self.NewBarFromDict(detailDict))
                            }
                            else
                            {
                                handler(false,"unknown server response",Bar())
                                let errorString = String(data: output, encoding: .utf8)
                                print("ERROR: \(errorString)")
                            }
                            
                        }
                        else
                        {
                            let detailString = dict["detail"] as? String
                            
                            guard detailString != nil else {return}
                            handler(false,detailString!,Bar())
                            
                        }
                    }
                    catch let error as NSError
                    {
                        NSLog(error.description)
                    }
                }
            }
        
        })
        
  
    }
    
    
    
    
    //====================================================================================
    //                                  DATA HANDLERS
    //====================================================================================
    
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
        
        var errors = [String]();
        
        let newBar = Bar()
        
        let ratingAvg = dict.value(forKey: "Bar_Rating_Avg") as? Float
        let ratingPrice = dict.value(forKey: "Bar_Rating_Price") as? Float
        let ratingAmbience = dict.value(forKey: "Bar_Rating_Ambience") as? Float
        let ratingFood = dict.value(forKey: "Bar_Rating_Food") as? Float
        let ratingService = dict.value(forKey: "Bar_Rating_Service") as? Float
        

        
        if let name = dict["Bar_Name"] as? String
        {
            newBar.name = name
        }
        else
        {
            errors.append("Bar has no Name")
        }
        
        
        if let ID = dict["Bar_ID"] as? Int
        {
            newBar.ID = String(describing: ID)
        }
        
        if let iconString = dict["Bar_Icon"] as? String
        {
            let dataDecoded:Data = Data(base64Encoded: iconString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            let icon = UIImage(data: dataDecoded)
            newBar.icon = icon
        }
        else
        {
            errors.append("no bar icon in dict")
        }
        
        if let description = dict["Bar_Description"] as? String
        {
            newBar.description = description
        }
        
        if let contact = dict["Bar_Contact"] as? String
        {
            newBar.contact = contact
        }
        
        
        //get opening hours
        if let monday = dict["OH_Monday"] as? String
        {
            newBar.openClosingHours[0] = monday
        }
        
        if let tuesday = dict["OH_Tuesday"] as? String
        {
            newBar.openClosingHours[1] = tuesday
        }
        
        if let wednesday = dict["OH_Wednesday"] as? String
        {
            newBar.openClosingHours[2] = wednesday
        }
        
        if let thursday = dict["OH_Thursday"] as? String
        {
            newBar.openClosingHours[3] = thursday
        }
        
        if let friday = dict["OH_Friday"] as? String
        {
            newBar.openClosingHours[4] = friday
        }
        
        if let saturday = dict["OH_Saturday"] as? String
        {
            newBar.openClosingHours[5] = saturday
        }
        
        if let sunday = dict["OH_Sunday"] as? String
        {
            newBar.openClosingHours[6] = sunday
        }
        
        if let loc_lat = dict["Bar_Location_Latitude"] as? String
        {
            newBar.loc_lat = Float(loc_lat)!
        }
        
        if let loc_long = dict["Bar_Location_Longitude"] as? String
        {
            newBar.loc_long = Float(loc_long)!
        }
        
        if let address = dict["Bar_Address"] as? String
        {
            newBar.address = address
        }
        
        if let bookingAvailable = dict.value(forKey: "Booking_Available") as? Int
        {
            newBar.bookingAvailable = String(describing: bookingAvailable)
        }

        if let website = dict["Bar_Website"] as? String
        {
            newBar.website = website
        }
        
        if ratingAvg != nil && ratingPrice != nil && ratingAmbience != nil && ratingFood != nil && ratingService != nil
        {
            newBar.rating.InjectValues(ratingAvg!, pricex: ratingPrice!, ambiencex:ratingAmbience!,foodx: ratingFood!, servicex: ratingService!)
        }
        else
        {
            errors.append("no rating in this dict")
        }
        
        if errors.count != 0
        {
            NSLog(errors.joined(separator: "\n"))
        }
        
        
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
            singleArray.sort(by: {$0.rating.avg > $1.rating.avg})
            displayBarList.append(singleArray)
            break;
        case .priceRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.price > $1.rating.price})
            displayBarList.append(singleArray)
            break;
        case .foodRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.food > $1.rating.food})
            displayBarList.append(singleArray)
            break;
        case .ambienceRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.ambience > $1.rating.ambience})
            displayBarList.append(singleArray)
            break;
        case .serviceRating:
            var singleArray = mainBarList
            singleArray.sort(by: {$0.rating.service > $1.rating.service})
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
