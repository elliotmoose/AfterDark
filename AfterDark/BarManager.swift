import Foundation

class BarManager: NSObject
{
    static let singleton = BarManager()
    //constants
    let urlAllBarNames = "http://mooselliot.net23.net/GetAllBarNames.php"
    
    //variables
    var mainBarList: [Bar] = []
    var displayBarList: [[Bar]] = [[]]
    var barListData = NSMutableData()
    //methods
    private override init()
    {
        
    }
    
    func ArrangeBarList(mode: DisplayBarListMode)
    {
        switch mode
        {
            case .alphabetical:
            
                //reset output
                displayBarList.removeAll()
                
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
                    
                    //add array to collection of arrays of letter-arranged bars
                    displayBarList.append(arrayOfBarsForLetter)
                }

                
            break
//            displayBarList.sort({$0[0].name < $1[0].name})
//        
//            case .avgRating:
//            displayBarList.sort {$0.rating.avg < $1.rating.avg}
//            case .priceRating:
//                displayBarList.sort{$0.rating.price < $1.rating.price}
//            case .foodRating:
//                            displayBarList.sort{$0.rating.price < $1.rating.price}
//            case .ambienceRating:
//                            displayBarList.sort{$0.rating.price < $1.rating.price}
//            case .serviceRating:
//                            displayBarList.sort{$0.rating.price < $1.rating.price}
            default:
                displayBarList.append(mainBarList);
//                displayBarList.sort {$0.name < $1.name}
//
        }
        
    }
    func LoadGenericData(callBack:() -> Void)
    {
        //Load All Bar Names
        LoadFromUrl(urlAllBarNames,CompleteCallBack: callBack)
        
    }
    
    
    //Load Method
    func LoadFromUrl(inputUrl: String, CompleteCallBack:()->Void) {
        
        let url = NSURL(string: inputUrl)!
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 15
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in

            if let error = error
            {
                print(error)
            }
            else if let data = data
            {
                let retrievedArray = self.JSONToArray(data.mutableCopy() as! NSMutableData)
                for index in 0...(retrievedArray.count - 1)
                {
                    let dict = retrievedArray[index] as! NSDictionary
                    let newBar = Bar()
                    newBar.name = dict.valueForKey("Bar_Name") as! String
                    self.mainBarList.append(newBar)
                }
                
                //callback to update UI
                CompleteCallBack()
            }
            
        })

        task.resume()

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
}
