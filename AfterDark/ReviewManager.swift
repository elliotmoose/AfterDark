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

    func LoadReviews(bar: Bar,lowerBound : Int,count: Int, handler:(success: Bool)-> Void)
    {
        var indexOfFirstReview = lowerBound
        var offset = 0
        //sort out which has been loaded and which to load
        while indexOfFirstReview < bar.reviews.count
        {
            indexOfFirstReview++
            offset++
            if offset >= count
            {
                //if function has been redundant (e.g ask for a load that has already been loaded
                return
            }
        }
        
        
        let urlGetReviewsForBar = "http://mooselliot.net23.net/GetReviewsForBar.php?Bar_ID=\(bar.ID)&LowerRangeLimit=\(indexOfFirstReview)&Count=\(count)"
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
                bar.reviews = bar.reviews + allReviewsForBar
                handler(success: true)
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

}