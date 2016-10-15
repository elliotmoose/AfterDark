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
        
        let url = NSURL(string: inputUrl)!
        let session = NSURLSession(configuration: default)
        
            (sessionWithoutADelegate.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
        } else if let response = response,
            let data = data,
            let string = String(data: data, encoding: .utf8) {
            print("Response: \(response)")
            print("DATA:\n\(string)\nEND DATA\n")
        }
        }).resume()

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
