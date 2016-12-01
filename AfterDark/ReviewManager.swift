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

    func LoadReviews(_ bar: Bar,lowerBound : Int,count: Int, handler:@escaping (_ success: Bool)-> Void)
    {
        var indexOfFirstReview = lowerBound
        var offset = 0
        //sort out which has been loaded and which to load
        while indexOfFirstReview < bar.reviews.count
        {
            indexOfFirstReview += 1
            offset += 1
            if offset >= count
            {
                //if function has been redundant (e.g ask for a load that has already been loaded
                return
            }
        }
        
        
        let urlGetReviewsForBar = Network.domain + "GetReviewsForBar.php?Bar_ID=\(bar.ID)&LowerRangeLimit=\(indexOfFirstReview)&Count=\(count)"
        Network.singleton.DictArrayFromUrl(urlGetReviewsForBar,handler: {(success,output)->Void in
        if success
        {
            if output.count != 0
            {
                var allReviewsForBar = [Review]()
                for dict in output
                {
                    var newReview = Review()
                    newReview.initWithDict(dict)
                    allReviewsForBar.append(newReview)
                }
                bar.reviews = allReviewsForBar
                handler(true)
            }
        }
        })
    }
    
    func LoadAllReviews()
    {
        for bar in BarManager.singleton.mainBarList
        {
            //load first 5 reviews
            ReviewManager.singleton.LoadReviews(bar,lowerBound: 0,count: 5,handler:
                {
                    (success) -> Void in
                    
                    if bar.name == BarManager.singleton.displayedDetailBar.name
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
                
                if dict["success"] as! String == "false"
                {
                    let errorMessage = dict["detail"] as! String
                    handler(false,errorMessage)
                }
                
                if dict["success"] as! String == "true"
                {
                    handler(true,"no error!")
                }
            }
            
        })

    }
}
