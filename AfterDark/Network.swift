import Foundation


class Network {
    
    var session : NSURLSession
    static let singleton = Network()

    init()
    {
        session = NSURLSession.sharedSession()
    }

    //Load Method
    func DataFromUrl(inputUrl: String, handler: (success:Bool,output : NSData?) -> Void) {
        
        let url = NSURL(string: inputUrl)!

        let task = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let error = error
            {
                print(error)
                handler(success: false,output: nil)

            }
            else if let data = data
            {
                handler(success: true,output: data)
            }
            
        })
        
        task.resume()
        
    }

    func StringFromUrl(inputUrl: String, handler: (success:Bool,output : String?) -> Void) {
        
        let url = NSURL(string: inputUrl)!
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let error = error
            {
                print(error)
                handler(success: false,output: nil)
                
            }
            else if let data = data
            {
                let outString = String(data: data, encoding: NSUTF8StringEncoding)
                handler(success: true,output: outString)
            }
            
        })
        
        task.resume()
        
    }

    
func DataFromUrlWithPost(inputUrl: String, postParam: String,handler: (success:Bool,output : NSData?) -> Void) {
        
        let url = NSURL(string: inputUrl)!

let request = NSMutableURLRequest(URL: url)
request.HTTPMethod = "POST"
request.HTTPBody = postParam.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let error = error
            {
                print(error)
                handler(success: false,output: nil)

            }
            else if let data = data
            {
                handler(success: true,output: data)
            }
            
        })
        
        task.resume()
        
    }




func DictArrayFromUrl(inputUrl: String, handler: (success:Bool,output : [NSDictionary]) -> Void) {
        
        let url = NSURL(string: inputUrl)!

        let task = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let error = error
            {
                print(error)
                handler(success: false,output: [])

            }
            else if let data = data
            {
                let out = data.mutableCopy() as! NSMutableData
                handler(success: true,output: self.JsonDataToDictArray(out))
            }
            
        })
        
        task.resume()
        
    }
func JsonDataToDictArray(data: NSMutableData) -> [NSDictionary]
    {
        var output = [NSDictionary]()
        var tempArr: NSMutableArray = NSMutableArray()
        
        do{

            let arr = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments)
            if arr.count == 0
            {
                print("invalid array, cant parse to JSON")
                return []
            }
            tempArr = arr as! NSMutableArray
            for index in 0...(tempArr.count - 1)
            {
                let intermediate = tempArr[index]
                if intermediate is NSDictionary
                {
                    let dict = intermediate as! NSDictionary
                    output.append(dict)
                }
            }
            
        } catch let error as NSError {
            print(error)
            
        }
        
        return output
    }
    
}