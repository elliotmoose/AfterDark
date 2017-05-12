import UIKit
class Bar : NSObject{
    
    var name : String
    var ID : String
    var rating = Rating()
    var totalReviewCount = 0
    
    var priceDeterminant = 0
    var discounts = [Discount]()
    var isExclusive = false
    //images
    var Images: [UIImage] = []
    var maxImageCount = -1
    
    var bar_description : String = ""
    var tags : String = ""
    //contact
    var contact : String = ""
    var website : String = ""
    
    //location
    var loc_long : Double = 0
    var loc_lat : Double = 0
    var address : String = ""
    var distanceFromClient : Float = 0
    var distanceFromClientString : String = ""
    var durationFromClient : Float = 0
    var durationFromClientString : String = ""
    var distanceMatrixEnabled = false

    var bestDiscount : Float = 0
    //opening hours
    var openClosingHours = [String]()
    
    var bookingAvailable: String
    
    //updating
    var lastUpdate : String = "Not Updated"
    
    
    //rating
    
    override init()
    {
        name = "Untitled"
        contact = ""
        website = ""
        ID = ""
        bookingAvailable = "0"

        for _ in 0...6
        {
            openClosingHours.append("nil")
        }
        
        
    }
    
    func populate(name : String, ID:String,rating:Rating,discounts : [Discount],icon : UIImage,images : [UIImage], maximagecount : Int, description : String, contact : String, website : String, loc_long : Double, loc_lat : Double, address : String, tags : String, priceDeterminant : Int)
    {
        self.name = name
        self.ID = ID
        self.rating = rating
        self.discounts = discounts
        self.Images = images
        self.maxImageCount = maximagecount
        self.bar_description = description
        self.contact = contact
        self.website = website
        self.loc_long = loc_long
        self.loc_lat = loc_lat
        self.address = address
        self.tags = tags
        self.priceDeterminant = priceDeterminant
    }
    
    func SetBestDiscount()
    {
        //reset
        bestDiscount = 0
        
        for discount in discounts
        {
            if let discountAmount = discount.amount
            {
                if discountAmount.contains("%")
                {
                    if let flatAmount = Float(discountAmount.components(separatedBy: "%")[0])
                    {
                        if flatAmount > bestDiscount
                        {
                            bestDiscount = flatAmount
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func SortDiscounts()
    {
        var exclusiveDisc = [Discount]()
        var normalDisc = [Discount]()
        
        for discount in discounts
        {
            if discount.exclusive
            {
                exclusiveDisc.append(discount)
            }
            else
            {
                normalDisc.append(discount)
            }
        }
        
        self.discounts = exclusiveDisc
        self.discounts.insert(contentsOf: normalDisc, at: exclusiveDisc.count)
    }
//
//    
//    func encodeWithCoder(aCoder : NSCoder)
//    {
//        aCoder.encode(self.name, forKey: "name")
//        aCoder.encode(self.ID, forKey: "ID")
//    }
//    
//    func decodeWithCoder(aDecoder : NSCoder)
//    {
//        if let name = aDecoder.decodeObject(forKey: "name") as? String
//        {
//            self.name = name
//        }
//        if let ID = aDecoder.decodeObject(forKey: "ID") as? String
//        {
//            self.ID = ID
//        }
//    }
}
