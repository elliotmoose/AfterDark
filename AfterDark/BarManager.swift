import foundation
import Bar

class BarManager: NSURLSessionDataDelegate
{
    //constants
    let urlAllBarNames = "http://mooselliot.net23.net/GetAllBarNames.php"
    
    //variables
    var mainBarList = [Bar]()
    var displayBarList = [[Bar]]()
    
    //methods
    func Init
    {
        //singleton
    }
    
    func LoadGenericData
    {
        //Load All Bar Names
        LoadFromUrl(inputUrl: urlAllBarNames)
        
    }
    
    
    //Load Method
    func LoadFromUrl(inputUrl: string) {
        
        let url: NSURL = NSURL(string: inputUrl)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
 
        
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(url)
        
        task.resume()
        
    }
    
    //receive data
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data);
        
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