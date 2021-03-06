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
    weak var bannerListDelegate : BarManagerToListTableDelegate?
    
    
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
                                        let newBar = Bar(barDict)
                                        
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
                                
                                barListOutput.append(Bar(barDict))
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
                PopupManager.singleton.GlobalPopup(title: "ERROR", body: "Check connection")
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
                                                        self.bannerListDelegate?.UpdateCellForBar(bar)
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
                    self.listDelegate?.UpdateBarListTableDisplay()
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
    
    func BarListIntoBarIDsList(_ list : [Bar]) -> [String]
    {
        var barIDs = [String]()
        for bar in list
        {
            barIDs.append(bar.ID)
        }
        
        return barIDs
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
    
            
    func UpdateUI()
    {
        DispatchQueue.main.async {
            self.listDelegate?.UpdateBarListTableDisplay()
            self.catListDelegate?.UpdateBarListTableDisplay()
            self.bannerListDelegate?.UpdateBarListTableDisplay()
        }

    }
    
    func AddViewForBarID(_ barID : String)
    {
        
        let url = Network.domain + "AddViewForBar.php"
        
        guard let barID = barID.AddPercentEncodingForURL(plusForSpace: true) else {return}
        let postParam = "Bar_ID=\(barID)"
        
        DispatchQueue.main.async {
            Network.singleton.DataFromUrlWithPost(url, postParam: postParam, handler:
                {
                    (success,output) -> Void in
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
                                    return
                                }
                            }
                            else
                            {
                                NSLog("invalid server response")
                            }
                        }
                        catch _ as NSError
                        {
                            NSLog("invalid server response")
                        }
                        }
                        else
                        {
                            NSLog("server fault: no response")
                        }
                        
                    }
                    
                    NSLog("failed to add view")
            })
        
        }

    }



}
