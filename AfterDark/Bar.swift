import UIKit
class Bar : NSObject{
    
    var name : String = "Untitled"
    var ID : String = ""
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
    var address_summary : String = ""
    var distanceFromClient : Float = 0
    var distanceFromClientString : String = ""
    var durationFromClient : Float = 0
    var durationFromClientString : String = ""
    var distanceMatrixEnabled = false

    var bestDiscount : Int = 0
    //opening hours
    var openClosingHours = [String]()
    
    var bookingAvailable: String = "0"
    
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
    
    init(_ dict : NSDictionary)
    {
        for _ in 0...6
        {
            openClosingHours.append("nil")
        }
        
        var errors = [String]();
        
        
        let ratingAvg = dict.value(forKey: "Bar_Rating_Avg") as? Float
        let ratingPrice = dict.value(forKey: "Bar_Rating_Price") as? Float
        let ratingAmbience = dict.value(forKey: "Bar_Rating_Ambience") as? Float
        let ratingFood = dict.value(forKey: "Bar_Rating_Food") as? Float
        let ratingService = dict.value(forKey: "Bar_Rating_Service") as? Float
        
        
        
        if let name = dict["Bar_Name"] as? String
        {
            self.name = name
        }
        else
        {
            self.name = ""
        }
        
        
        if let ID = dict["Bar_ID"] as? Int
        {
            self.ID = String(describing: ID)
        }
        
        
        if let description = dict["Bar_Description"] as? String
        {
            self.bar_description = description
        }
        
        if let contact = dict["Bar_Contact"] as? String
        {
            self.contact = contact
        }
        
        if let tags = dict["Bar_Tags"] as? String
        {
            self.tags = tags
        }
        
        if let priceDeterminant = dict["Bar_PriceDeterminant"] as? Int
        {
            self.priceDeterminant = priceDeterminant
        }
        else if let priceDeterminant = dict["Bar_PriceDeterminant"] as? String
        {
            if let determinant = Int(priceDeterminant)
            {
                self.priceDeterminant = determinant
            }
        }
        
        if let lastUpdate = dict["lastUpdate"] as? String
        {
            self.lastUpdate = lastUpdate
        }
        else if let lastUpdate = dict["lastUpdate"] as? Int
        {
            self.lastUpdate = "\(lastUpdate)"
        }
        
        //get opening hours
        if let monday = dict["OH_Monday"] as? String
        {
            self.openClosingHours[0] = monday
        }
        
        if let tuesday = dict["OH_Tuesday"] as? String
        {
            self.openClosingHours[1] = tuesday
        }
        
        if let wednesday = dict["OH_Wednesday"] as? String
        {
            self.openClosingHours[2] = wednesday
        }
        
        if let thursday = dict["OH_Thursday"] as? String
        {
            self.openClosingHours[3] = thursday
        }
        
        if let friday = dict["OH_Friday"] as? String
        {
            self.openClosingHours[4] = friday
        }
        
        if let saturday = dict["OH_Saturday"] as? String
        {
            self.openClosingHours[5] = saturday
        }
        
        if let sunday = dict["OH_Sunday"] as? String
        {
            self.openClosingHours[6] = sunday
        }
        
        if let loc_lat = dict["Bar_Location_Latitude"] as? String
        {
            self.loc_lat = Double(loc_lat)!
        }
        else if let loc_lat = dict["Bar_Location_Latitude"] as? Double
        {
            self.loc_lat = loc_lat
        }
        
        if let loc_long = dict["Bar_Location_Longitude"] as? String
        {
            self.loc_long = Double(loc_long)!
        }
        else if let loc_long = dict["Bar_Location_Longitude"] as? Double
        {
            self.loc_long = loc_long
        }
        
        if let address = dict["Bar_Address"] as? String
        {
            self.address = address
        }
        
        if let bookingAvailable = dict.value(forKey: "Booking_Available") as? Int
        {
            self.bookingAvailable = String(describing: bookingAvailable)
        }
        
        if let website = dict["Bar_Website"] as? String
        {
            self.website = website
        }
        
        if let ratingCount = dict["Bar_Rating_Count"] as? String
        {
            if let count = Int(ratingCount)
            {
                self.totalReviewCount = count
            }
        }
        else if let ratingCount = dict["Bar_Rating_Count"] as? Int
        {
            self.totalReviewCount = ratingCount
        }
        
        if ratingAvg != nil && ratingPrice != nil && ratingAmbience != nil && ratingFood != nil && ratingService != nil
        {
            self.rating.InjectValues(ratingAvg!, pricex: ratingPrice!, ambiencex:ratingAmbience!,foodx: ratingFood!, servicex: ratingService!)
        }
        else
        {
            errors.append("no rating in this dict")
        }
        
        if let maxImageCount = dict["maxImageCount"] as? Int
        {
            self.maxImageCount = maxImageCount
        }
        else if let maxImageCount = dict["maxImageCount"] as? String
        {
            if let count = Int(maxImageCount)
            {
                self.maxImageCount = count
            }
        }
        else
        {
            errors.append("no max image count in dict")
        }
        
        if errors.count != 0
        {
            NSLog(errors.joined(separator: "\n"))
        }
        
        if let isExclusive = dict["Exclusive"] as? Bool
        {
            self.isExclusive = isExclusive
        }
        
        if let addressSummary = dict["Bar_Address_Summary"] as? String
        {
            self.address_summary = addressSummary
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
            if discount.discount_rating > bestDiscount
            {
                bestDiscount = discount.discount_rating
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
