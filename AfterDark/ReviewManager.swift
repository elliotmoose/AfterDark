class ReviewManager
{
    static let singleton = ReviewManager()
    
    func init()
    {
        
        
    }

    func LoadReviews(bar: Bar, handler:(success: Bool)-> Void)
    {
        let thisBarFormatName = bar.name.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let urlGetReviewsForBar = "http://mooselliot.net23.net/GetReviewsForBar.php?Bar_Name=\(thisBarFormatName)&LowerRangeLimit="
        Network.singleton.DictArrayFromUrl(urlGetReviewsForBar,{(success,output)->Void in
        if success
        {
            if let output = output
            {
                bar.Reviews += 
            }
        }
        })
    }
}