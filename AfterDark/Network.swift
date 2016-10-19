class :Network
{
    static let singleton = Network()
    var session : NSURLSession
    
    func Initialize()
    {
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 15
        let session = NSURLSession(configuration: config)
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
}