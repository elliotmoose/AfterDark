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

    func LoadAllReviews()
    {
        for bar in BarManager.singleton.mainBarList
        {
            //load first 5 reviews
            ReviewManager.singleton.LoadReviews(bar,lowerBound: 0,count: 5,handler:
                {
                    (success) -> Void in
                    
                    if BarManager.singleton.displayedDetailBar != nil && bar.name == BarManager.singleton.displayedDetailBar?.name
                    {
                        self.delegate?.UpdateReviewTab()
                        
                    }
                    
                    
            })
        }
    }
    
    func LoadReviews(_ bar: Bar,lowerBound : Int,count: Int, handler:@escaping (_ success: Bool)-> Void)
    {
        var indexOfFirstReview = lowerBound
        var offset = 0
        //sort out which has been loaded and which to load
        //while index of first review to load is less than the number of reviews (e.g asking to load review 0 but reviews 0 to 3 have already been loaded. so increase index until 4 so that it doesnt reload 0-3)
        while indexOfFirstReview < bar.reviews.count
        {
            indexOfFirstReview += 1
            offset += 1
            if offset >= count
            {
                //if loading smth that has already been loaded
                return
            }
        }
        
        guard let userID = Account.singleton.user_ID else {return}
        
        let urlGetReviewsForBar = Network.domain + "GetReviewsForBar.php?Bar_ID=\(bar.ID)&LowerRangeLimit=\(indexOfFirstReview)&Count=\(count)&User_ID=\(userID)"
        Network.singleton.DictArrayFromUrl(urlGetReviewsForBar,handler: {(success,output)->Void in
        if success
        {
            if output.count != 0
            {
                var allReviewsForBar = [Review]()
                for dict in output
                {
                    if let count = dict["COUNT(*)"] as? Int
                    {
                        bar.totalReviewCount = count
                    }
                    else
                    {
                        var newReview = Review()
                        newReview.initWithDict(dict)
                        allReviewsForBar.append(newReview)
                    }
                }
                
                bar.reviews = allReviewsForBar
                
                
                handler(true)
            }
        }
        })
    }
    

    
    func ReloadReviews(_ bar: Bar,lowerBound : Int,count: Int, handler:@escaping (_ success: Bool)-> Void)
    {
        
        bar.reviews.removeAll()
        
        let urlGetReviewsForBar = Network.domain + "GetReviewsForBar.php?Bar_ID=\(bar.ID)&LowerRangeLimit=\(lowerBound)&Count=\(count)&User_ID=\(Account.singleton.user_ID!)"
        Network.singleton.DictArrayFromUrl(urlGetReviewsForBar,handler: {(success,output)->Void in
            if success
            {
                if output.count != 0
                {
                    var allReviewsForBar = bar.reviews
                    for dict in output
                    {
                        if let count = dict["COUNT(*)"] as? Int
                        {
                            bar.totalReviewCount = count
                        }
                        else
                        {
                            var newReview = Review()
                            newReview.initWithDict(dict)
                            allReviewsForBar.append(newReview)
                        }
                        
                        
                        
                    }
                    bar.reviews = allReviewsForBar
                    
                    handler(true)
                }
            }
        })
    }
    
    func ReloadAllReviews()
    {
        for bar in BarManager.singleton.mainBarList
        {
            //load first 5 reviews
            ReviewManager.singleton.ReloadReviews(bar,lowerBound: 0,count: 5,handler:
                {
                    (success) -> Void in
                    
                    if BarManager.singleton.displayedDetailBar != nil && bar.name == BarManager.singleton.displayedDetailBar?.name
                    {
                        self.delegate?.UpdateReviewTab()
                    }
                    
                    
            })
        }
    }
    func AddReview(title : String,body : String, rating : Rating,bar : Bar,userID : String,handler: @escaping (_ success : Bool,_ error : String) -> ())
    {
        
        let url = Network.domain + "/AddReview.php"
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
