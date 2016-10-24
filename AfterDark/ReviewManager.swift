import Foundation

class ReviewManager
{
    static let singleton = ReviewManager()
    
    init()
    {
        
        
    }

    func LoadReviews(bar: Bar,lowerBound : Int,upperBound: Int, handler:(success: Bool)-> Void)
    {
        
        let thisBarFormatName = bar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let urlGetReviewsForBar = "http://mooselliot.net23.net/GetReviewsForBar.php?Bar_Name=\(thisBarFormatName)&LowerRangeLimit=\(lowerBound)&UpperRangeLimit=\(upperBound)"
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
                bar.reviews += allReviewsForBar
            }
        }
        })
    }
}