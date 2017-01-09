import Foundation
protocol ReviewManagerToBarDetailContDelegate: class
{
    func UpdateReviewTab()
}

class ReviewManager
{
    static let singleton = ReviewManager()
    weak var delegate: ReviewManagerToBarDetailContDelegate?
    init()
    {
        
        
    }

    func GetCanGiveReview(forBarID : String, handler : @escaping (Bool) -> Void)
    {
        let url = Network.domain + "CanGiveReview.php"
        guard let userID = Account.singleton.user_ID else {handler(false);return}
        let postParam = "User_ID=\(userID)&Bar_ID=\(forBarID)"
        
        Network.singleton.DataFromUrlWithPost(url, postParam: postParam) {
            (success, output) in
            
            var canGiveReview = true // default
            if let output = output
            {
                if success
                {
                    do
                    {
                        if let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? NSDictionary
                        {
                            if let succ = dict["success"] as? String
                            {
                                if succ == "true"
                                {
                                    canGiveReview = true
                                }
                                else
                                {
                                    canGiveReview = false
                                }
                            }
                            else
                            {
                                canGiveReview = false
                                NSLog("invalid server response in GetCanGiveReview()")
                            }
                        }
                        else
                        {
                            NSLog("invalid server response in GetCanGiveReview()")
                        }
                    }
                    catch let error as NSError
                    {

                    }
                }
                else
                {
                    NSLog("check connection")
                }
                
            }
            else
            {
                NSLog("check connection; no server response")
            }
            
            handler(canGiveReview)
        }
    }
    
    func AddReview(title : String,body : String, rating : Rating,bar : Bar,userID : String,handler: @escaping (_ success : Bool,_ error : String) -> ())
    {
        
        let url = Network.domain + "AddReview.php"
        let postParam = "title=\(title)&body=\(body)&avg=\(rating.avg)&price=\(rating.price)&food=\(rating.food)&service=\(rating.service)&ambience=\(rating.ambience)&Bar_ID=\(bar.ID)&User_ID=\(userID)"
        
        Network.singleton.DataFromUrlWithPost(url,postParam: postParam,handler: {(success,output) -> Void in
            
            if let output = output
            {
                let jsonData = (output as NSData).mutableCopy() as! NSMutableData
                
                NSLog(String(data: output, encoding: .utf8)!)
                let dict = Network.JsonDataToDict(jsonData)
                
                if let success = dict["success"] as? String
                {
                    if success == "false"
                    {
                        let errorMessage = dict["detail"] as! String
                        handler(false,errorMessage)
                    }
                    
                    if success == "true"
                    {
                        handler(true,"no error!")
                    }
                    
                }
                
                handler(false,"server failed to handle request")
                print(String(data: output, encoding: .utf8))
                
                
            }
            
            handler(false,"cant connect to server")

            
        })

    }
}
