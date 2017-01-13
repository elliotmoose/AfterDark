import Foundation


class Network {
    static let errorsOn = false
    
    var session : URLSession
    static let singleton = Network()

    
    //Urls
    //static let domain = "http://mooselliot.net23.net/"
    static let domain = "http://localhost/AfterDarkServer/"
//    static let domain = "http://mooselliot.com/AfterDarkServer/"
    
    init()
    {
        session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 10
    }
    
    //Load Method
    func DataFromUrl(_ inputUrl: String, handler: @escaping (_ success:Bool,_ output : Data?) -> Void) {
        
        let url = URL(string: inputUrl)!
        
        let task = session.dataTask(with: url)
        { data, response, error in
            
            if let error = error
            {
                
                if Network.errorsOn
                {
                    print(error)
                }
                
                DispatchQueue.main.async {
                    handler(false,nil)
                }
            }
            else if let data = data
            {
                DispatchQueue.main.async {
                    handler(true,data)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    handler(false,nil)
                }
            }
            
        }
        
        task.resume()
        
    }
    
    func StringFromUrl(_ inputUrl: String, handler: @escaping (_ success:Bool,_ output : String?) -> Void) {
        
        let url = URL(string: inputUrl)!
        
        let task = session.dataTask(with: url)
        {
            data, response, error in
            
            if let error = error
            {
                if Network.errorsOn
                {
                    print(error)
                }
                DispatchQueue.main.async {
                    handler(false,nil)
                }
            }
            else if let data = data
            {
                let outString = String(data: data, encoding: String.Encoding.utf8)
                DispatchQueue.main.async {
                    handler(true,outString)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    handler(false,nil)
                }
            }
            
        }
        
        task.resume()
        
    }
    
    //post functions
    func StringFromUrlWithPost(_ inputUrl: String, postParam: String,handler: @escaping (_ success:Bool,_ output : String?) -> Void) {
        
        let url = URL(string: inputUrl)!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postParam.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        { data, response, error in
            
            
            if let error = error
            {
                if Network.errorsOn
                {
                    print(error)
                }
                
                DispatchQueue.main.async {
                    handler(false,nil)
                }
                
                
            }
            else if let data = data
            {
                let outString = String(data: data, encoding: String.Encoding.utf8)
                DispatchQueue.main.async {
                    handler(true,outString)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    handler(false,nil)
                }
            }
            
        }
        
        task.resume()
        
    }
    
    func DataFromUrlWithPost(_ inputUrl: String, postParam: String,handler: @escaping (_ success:Bool,_ output : Data?) -> Void) {
        
        let url = URL(string: inputUrl)!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postParam.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        { data, response, error in
            
            
            if let error = error
            {
                if Network.errorsOn
                {
                    print(error)
                }
                
                DispatchQueue.main.async {
                    handler(false,nil)
                }
                
                
            }
            else if let data = data
            {
                DispatchQueue.main.async {
                    handler(true,data)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    handler(false,nil)
                }
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    
    static func JsonDataToDict(_ data : NSMutableData) -> NSDictionary
    {
        var output = NSDictionary()
        
        do{
            
            output = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            
            
        } catch let error as NSError {
            if Network.errorsOn
                {
                    print(error)
                }
            
        }
        
        return output
    }
}


