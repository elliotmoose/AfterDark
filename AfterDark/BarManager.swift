import Foundation
import UIKit
import GoogleMaps

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
    
    //variables
    var mainBarList: [Bar] = []
    var barListIcons: [NSDictionary] = []
    var displayedDetailBar : Bar? = nil
    weak var detailDelegate:BarManagerToDetailTableDelegate?
    weak var listDelegate :BarManagerToListTableDelegate?
    weak var catListDelegate :BarManagerToListTableDelegate?

    
    //note: this is called in inital: handler calls discounts load and distance matrix load
    func InitialLoadAllBars(handler : @escaping () -> Void) //*** this must be done after cache has been loaded
    {
        //step 1: check cache
        if CacheManager.singleton.HasBarCache() //step 1a, hasBarCache == true
        {
            //step 2: load cache and push to ui
            self.mainBarList = CacheManager.singleton.cachedBarList!
            
            self.UpdateUI()
            
            //step 3: check for updates
            
            //step 3i: load new bar list
            self.GetNewBarList(handler:
            { (success, output) in
                
                if success
                {
                    //step 3ii: check if any new bars
                    var newBars = [Bar]()
                    var oldBars = [Bar]()
                    
                    for bar in output
                    {
                        if self.mainBarList.contains(where: {$0.ID == bar.ID})
                        {
                            oldBars.append(bar)
                        }
                        else
                        {
                            newBars.append(bar)
                        }
                    }
                    
                    //step 3iiia: old bars IDs: compare lastUpDates with current
                    for bar in oldBars
                    {
                        //if different, force update this bar
                        if self.BarFromBarID(bar.ID)?.lastUpdate != bar.lastUpdate
                        {
                            //soft load bar with update check
                        }
                        else
                        {
                            //do nothing
                        }
                    }
                    
                    //step 3iiib: new bars IDs: soft load bar
                    for bar in newBars
                    {
                        //soft load bar (discounts already loaded just need to push)
                        
                    }
                    
                    handler()
                    
                }
                else
                {
                    //do nothing
                }
            })

            
        
            
        }
        else //step 1b, hasBarCache == false
        {
            //soft load
            self.HardLoadAllBars {
                self.UpdateUI()
                handler()
            }
        }
        
    }
    
    func HardLoadBar(barID : String,_ handler : @escaping () -> Void) //does not include images and discounts
    {
        let url = Network.domain + "LoadBarWithID.php?\(barID)"
        Network.singleton.DataFromUrl(url) { (success, output) in
            if success
            {
                if let output = output
                {
                    do
                    {
                        if let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? NSDictionary
                        {
                            if let succ = dict["success"] as? String
                            {
                                if succ == "true"
                                {
                                    if let barDict = dict["detail"] as? NSDictionary
                                    {
                                        let newBar = self.NewBarFromDict(barDict)
                                        
                                        //if there is an old version of the bar present -> update
                                        if self.mainBarList.contains(where: {$0.ID == newBar.ID})
                                        {
                                            //update and save
                                            if !self.UpdateBarWithBarID(newBar.ID, bar: newBar)
                                            {
                                                self.mainBarList.append(newBar)
                                                
                                                //save
                                                CacheManager.singleton.Save()
                                            }
                                            
                                            
                                        }
                                        else //else add and save
                                        {
                                            self.mainBarList.append(newBar)
                                            
                                            //save
                                            CacheManager.singleton.Save()
                                        }
                                        
                                        
                                        
                                        //update ui
                                        self.UpdateUI()
                                        
                                        
                                        
                                        
                                        handler()
                                        return
                                    }
                                }
                                else
                                {
                                    NSLog(dict["detail"] as! String)
                                }
                                
                            }
                            else
                            {
                                NSLog("invalid server response")
                            }
                        }
                        else
                        {
                            NSLog("invalid server response")
                        }
                    }
                    catch
                    {
                        NSLog("invalid server response")
                    }
                }
                else
                {
                    NSLog("server fault: no server response")
                }
            }
            else
            {
                NSLog("Please check connection")
            }
        }
        
        handler()
        
    }
    
    func UpdateBarWithBarID(_ barID : String, bar : Bar) -> Bool
    {
        var hasBarWithID = false
        var indexOfBar = -1
        
        guard mainBarList.count > 0 else {return false}
        
        for i in 0...mainBarList.count-1
        {
            let thisBar = mainBarList[i]
            if thisBar.ID == bar.ID
            {
                indexOfBar = i
                hasBarWithID = true
            }
        }
        
        guard indexOfBar != -1 else {return false}
        
        mainBarList[indexOfBar] = bar
        
        //save
        CacheManager.singleton.Save()
        
        return hasBarWithID
    }
    func HardLoadAllBars(_ handler : @escaping () -> Void) //does not include images and discounts
    {
        let url = Network.domain + "HardLoadAllBars.php"
        Network.singleton.DataFromUrl(url)
        {
            (success, output) in
            
            var barListOutput = [Bar]()
            if success
            {
                if let output = output
                {
                    do
                    {
                        if let barArr = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? [NSDictionary]
                        {
                            for barDict in barArr
                            {
                                let bar = BarManager.singleton.NewBarFromDict(barDict)
                                barListOutput.append(bar)
                            }
                            
                        }
                        else
                        {
                            NSLog("ERROR: server response for SoftLoadAllBars() invalid")
                            return
                        }
                        
                    }
                    catch let error as NSError
                    {
                        NSLog("\(error)")
                    }
                }
            }
            else
            {
                NSLog("Could not connect,check connection")
                return
            }
            
            //make sure its not empty
            guard barListOutput.count != 0 else {return}
            
            //set main list
            BarManager.singleton.mainBarList = barListOutput
            
//            //set cache list
//            CacheManager.singleton.cachedBarList = barListOutput
//            
//            //save cache
//            CacheManager.singleton.Save()
            
            //updates displayed bar
            if let bar = self.displayedDetailBar
            {
                //takes the ID of the current displayed bar(not updated version) to get an updated version from the new list
                self.displayedDetailBar = self.BarFromBarID(bar.ID)
            }
            
            DispatchQueue.main.async {
                
                //update ui
                self.UpdateUI()
                
                //handler
                handler()
            }
            
            
        }
        
    }
    
    
    func GetNewBarList(handler : @escaping (Bool,[Bar]) -> Void)
    {
        let url = Network.domain + "GetBarUpdates.php"
        
        Network.singleton.DataFromUrl(url) { (success, output) in
            if success
            {
                if let output = output
                {
                    do
                    {
                        if let dictArr = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? [NSDictionary]
                        {
                            var output = [Bar]()
                            
                            for dict in dictArr
                            {
                                output.append(self.NewBarFromDict(dict))
                            }
                            
                            handler(true,output)
                            return
                        }
                        else
                        {
                            NSLog("invalid server response")
                        }
                    }
                    catch let _ as NSError
                    {
                        NSLog("invalid server response")
                    }
                }
                else
                {
                    NSLog("server fault: no response")
                }
            }
            else
            {
                NSLog("Please check connection")
            }
        }
        
        handler(false,[])
    }
    
    
    
    //====================================================================================
    //                                  LOAD DISTANCE TIME FOR BAR
    //====================================================================================
    private func LoadDistanceMatrixForBar(_ bar: Bar, handler : @escaping (Bool,NSDictionary?) -> Void)
    {
        
        DispatchQueue.main.async {
            
            //get time and distance from current location
            let locationManager = LocationManager.singleton
            
            var myLocation = locationManager.location?.coordinate
            
            if myLocation == nil
            {
                myLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
            
            //test
            let myLat = myLocation!.latitude
            let myLong = myLocation!.longitude
            
            var mode = "transit"
            switch Settings.travelMode {
            case .Walk:
                mode = "walking"
            case .Transit:
                mode = "transit"
            case .Drive:
                mode = "driving"
            }
            
            //uses as a proxy
            let url = Network.domain + "QueryDistanceMatrix.php"
            
            let param = "units=metric&origins=\(myLat),\(myLong)&destinations=\(bar.loc_lat),\(bar.loc_long)&key=\(Settings.googleServicesServerKey)&mode=\(mode)"
            
            DispatchQueue.main.async {
                Network.singleton.DataFromUrlWithPost(url, postParam: "parameters=\(param.AddPercentEncodingForURL(plusForSpace: true)!)", handler:
                    {
                        (success,output) -> Void in
                        
                        
                        if success
                        {
                            
                            do
                            {
                                if let dict = try JSONSerialization.jsonObject(with: output!, options: .allowFragments) as? NSDictionary
                                {
                                    
                                    if let error = dict["error_message"] as? String
                                    {
                                        NSLog(error)
                                    }
                                    
                                    if let rowsArr = dict["rows"] as? NSArray
                                    {
                                        
                                        guard rowsArr.count > 0 else {return}
                                        if let row = rowsArr[0] as? NSDictionary
                                        {
                                            if let elementsArr = row["elements"] as? NSArray
                                            {
                                                if let element = elementsArr[0] as? NSDictionary
                                                {
                                                    //UPDATE DATA
                                                    if let distance = element["distance"] as? NSDictionary
                                                    {
                                                        if let text = distance["text"] as? String
                                                        {
                                                            bar.distanceFromClientString = text
                                                        }
                                                        
                                                        if let value = distance["value"] as? Float
                                                        {
                                                            bar.distanceFromClient = value
                                                        }
                                                    }
                                                    
                                                    if let duration = element["duration"] as? NSDictionary
                                                    {
                                                        if let text = duration["text"] as? String
                                                        {
                                                            bar.durationFromClientString = text
                                                        }
                                                        
                                                        if let value = duration["value"] as? Float
                                                        {
                                                            bar.durationFromClient = value
                                                        }
                                                    }
                                                    
                                                    bar.distanceMatrixEnabled = true
                                                    
                                                    DispatchQueue.main.async {
                                                        //UPDATING OF UI
                                                        self.catListDelegate?.UpdateCellForBar(bar)
                                                        self.listDelegate?.UpdateCellForBar(bar)
                                                    }
                                                    
                                                    
                                                    handler(true, element)
                                                    return
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                let outString = String(data: output!, encoding: .utf8)!
                                print(outString)
                                
                            }
                            catch let error as NSError
                            {
                                
                            }
                            
                        }
                        
                        //if it reaches here means failed
                        handler(false,nil)
                        bar.durationFromClientString = ""
                        bar.distanceFromClientString = ""
                        bar.distanceMatrixEnabled = false
                        
                        
                })

            }
        }
    }
    
    func ReloadAllDistanceMatrix()
    {
        for bar in mainBarList
        {
            //LOADING OF DATA
            self.LoadDistanceMatrixForBar(bar, handler: {
                (success,output) -> Void in
                
                if success
                {
                    
                }
                else
                {

                }
                
                
            })
        }
    }
    
    //====================================================================================
    //                                  DATA HANDLERS
    //====================================================================================
    
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
        
        
        if let description = dict["Bar_Description"] as? String
        {
            newBar.bar_description = description
        }
        
        if let contact = dict["Bar_Contact"] as? String
        {
            newBar.contact = contact
        }
        
        if let tags = dict["Bar_Tags"] as? String
        {
            newBar.tags = tags
        }
 
        if let priceDeterminant = dict["Bar_PriceDeterminant"] as? Int
        {
            newBar.priceDeterminant = priceDeterminant
        }
        else if let priceDeterminant = dict["Bar_PriceDeterminant"] as? String
        {
            if let determinant = Int(priceDeterminant)
            {
                newBar.priceDeterminant = determinant
            }
        }
        
        if let lastUpdate = dict["lastUpdate"] as? String
        {
            newBar.lastUpdate = lastUpdate
        }
        else if let lastUpdate = dict["lastUpdate"] as? Int
        {
            newBar.lastUpdate = "\(lastUpdate)"
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
            newBar.loc_lat = Double(loc_lat)!
        }
        else if let loc_lat = dict["Bar_Location_Latitude"] as? Double
        {
            newBar.loc_lat = loc_lat
        }
        
        if let loc_long = dict["Bar_Location_Longitude"] as? String
        {
            newBar.loc_long = Double(loc_long)!
        }
        else if let loc_long = dict["Bar_Location_Longitude"] as? Double
        {
            newBar.loc_long = loc_long
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
        
        if let ratingCount = dict["Bar_Rating_Count"] as? String
        {
            if let count = Int(ratingCount)
            {
                newBar.totalReviewCount = count
            }
        }
        else if let ratingCount = dict["Bar_Rating_Count"] as? Int
        {
            newBar.totalReviewCount = ratingCount
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
    
    func UpdateUI()
    {
        DispatchQueue.main.async {
            self.listDelegate?.UpdateBarListTableDisplay()
            self.catListDelegate?.UpdateBarListTableDisplay()
        }

    }
    
    
    
}
