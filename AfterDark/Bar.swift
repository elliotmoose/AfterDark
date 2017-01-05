import UIKit
class Bar{
    var name : String
    var ID : String
    var rating = Rating()
    var reviews = [Review]()
    var totalReviewCount = 0
    
    var discounts = [Discount]()
    
    //images
    var Images: [UIImage] = []
    var maxImageCount = -1
    
    var description : String = ""
    
    //contact
    var contact : String = ""
    var website : String = ""
    
    //location
    var loc_long : Float = 0
    var loc_lat : Float = 0
    var address : String = ""
    var distanceFromClient : Float = 0
    var distanceFromClientString : String = ""
    var durationFromClient : Float = 0
    var durationFromClientString : String = ""
    var distanceMatrixEnabled = false

    
    //opening hours
    var openClosingHours = [String]()
    
    
    var bookingAvailable: String
    
    
    
    //rating
    
    init()
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
    
    func populate(name : String, ID:String,rating:Rating,reviews:[Review],discounts : [Discount],icon : UIImage,images : [UIImage], maximagecount : Int, description : String, contact : String, website : String, loc_long : Float, loc_lat : Float, address : String)
    {
        self.name = name
        self.ID = ID
        self.rating = rating
        self.reviews = reviews
        self.discounts = discounts
        self.Images = images
        self.maxImageCount = maximagecount
        self.description = description
        self.contact = contact
        self.website = website
        self.loc_long = loc_long
        self.loc_lat = loc_lat
        self.address = address
    }
    
    
}
