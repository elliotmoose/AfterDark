import Foundation

class BarManager: NSObject, NSURLSessionDataDelegate
{
    static let singleton = BarManager()
    //constants
    let urlAllBarNames = "http://mooselliot.net23.net/GetAllBarNames.php"
    
    //variables
    var mainBarList: [Bar] = []
    var displayBarList: [[Bar]] = [[]]
    
    //methods
    private override init()
    {
        
    }
    
    func ArrangeBarList(mode: DisplayBarListMode)
    {
        switch mode
        {
            case .alphabetical: break
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
    func LoadGenericData()
    {
        //Load All Bar Names
        LoadFromUrl(urlAllBarNames)
        
    }
    
    
    //Load Method
    func LoadFromUrl(inputUrl: String) {
        
        let url: NSURL = NSURL(string: inputUrl)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
 
        
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(url)
        
        task.resume()
        
    }
    
    //receive data
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
    //    self.data.appendData(data);
        
    }
    
    //Load finished
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            //execute manipulation of data (json-> array-> maniuplate)
        }
        
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
