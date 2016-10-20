import Foundation


class Network {
    
    var session : NSURLSession
    static let singleton = Network()

    init()
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 15
        session = NSURLSession(configuration: config)
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

let config = NSURLSessionConfiguration.defaultSessionConfiguration()
config.timeoutIntervalForRequest = 15
        let newSession = NSURLSession(configuration:config)

let request = NSMutableURLRequest(URL: url)
request.HTTPMethod = "POST"
request.HTTPBody = postParam.dataUsingEncoding(NSUTF8StringEncoding)

        let task = newSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
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
}