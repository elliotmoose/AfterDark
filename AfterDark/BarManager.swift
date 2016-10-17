import Foundation
import UIKit
protocol BarManagerDelegate :class
{
    func UpdateBarListTableDisplay()
}

class BarManager: NSObject
{
    static let singleton = BarManager()
    //constants
    let urlAllBarNames = "http://mooselliot.net23.net/GetAllBarNames.php"
    let urlBarIconImage = "http://mooselliot.net23.net/GetBarIconImage.php"
    //let urlAllBarNames = "https://afterdark/GetAllBarNames.php"
    
    
    
    //variables
    var mainBarList: [Bar] = []
    var displayBarList: [[Bar]] = [[]]
    var barListIcons: [NSDictionary] = []
    
    weak var delegate:BarManagerDelegate?
    
    //methods
    private override init()
    {
        
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
    func LoadGenericBarData()
    {
        //Load All Bar Names
        LoadFromUrl(urlAllBarNames,completionHandler: {(succes) -> Void in
        
            
            //callback to update UI before continue loading images
            self.delegate?.UpdateBarListTableDisplay()

            //Load BarIcon
            self.LoadFromUrl(self.urlBarIconImage, completionHandler: {(success) ->Void in
            
            //inject icons
            
                
            //update UI
            self.delegate?.UpdateBarListTableDisplay()

            })
        });
    }
    
    
    //Load Method
    func LoadFromUrl(inputUrl: String, completionHandler:CompletionHandler) {
        
        let url = NSURL(string: inputUrl)!
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 15
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let error = error
            {
                print(error)
                completionHandler!(success: false)

            }
            else if let data = data
            {
                //check: if is urlwithtask getbarlist
                switch inputUrl
                {
                case self.urlAllBarNames:
                    self.HandleGetBarListData(data)
                case self.urlBarIconImage:
                    self.HandleGetAllBarIcons(data)
                default: break
                }
                
                completionHandler!(success: true)
            }
            
        })
        
        task.resume()
        
    }
    
    //different data handlers
    func HandleGetBarListData(data:NSData)
    {
        
        
        let retrievedArray = self.JSONToArray(data.mutableCopy() as! NSMutableData)
        
        //reset output
        self.mainBarList.removeAll()
        for index in 0...(retrievedArray.count - 1)
        {
            let dict = retrievedArray[index] as! NSDictionary
            self.mainBarList.append(self.NewBarFromDict(dict))
        }
    }
    
    func HandleGetAllBarIcons(data:NSData)
    {
        let retrievedArray = self.JSONToArray(data.mutableCopy() as! NSMutableData)
        
        //reset output
        self.barListIcons.removeAll()
        for index in 0...(retrievedArray.count - 1)
        {
            let barDict = retrievedArray[index] as! NSDictionary
            self.barListIcons.append(barDict)
        }
        
        //inject icons into data array
        for index in 0...(mainBarList.count-1)
        {
            let thisBar = mainBarList[index]
            for i in 0...(barListIcons.count-1)
            {
                if barListIcons[i].valueForKey("Bar_Name") as? String == thisBar.name
                {
                    let base64Image = barListIcons[i].valueForKey("Bar_Icon") as? String
                    if let base64Image = base64Image
                    {
                        let dataDecoded:NSData = NSData(base64EncodedString: base64Image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                        thisBar.icon = UIImage(data: dataDecoded)
                    }

                }
            }
        }
    }
    
    func NewBarFromDict(dict: NSDictionary) ->Bar
    {
        let newBar = Bar()
        newBar.name = dict.valueForKey("Bar_Name") as! String
        newBar.rating.InjectValues(Float(dict.valueForKey("Bar_Rating_Avg") as! String)!, pricex: Float(dict.valueForKey("Bar_Rating_Price") as! String)!, ambiencex: Float(dict.valueForKey("Bar_Rating_Ambience") as! String)!,foodx: Float(dict.valueForKey("Bar_Rating_Food") as! String)!, servicex: Float(dict.valueForKey("Bar_Rating_Service") as! String)!)
        
        return newBar
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
    typealias CompletionHandler = ((success:Bool) -> Void)?
    
}
