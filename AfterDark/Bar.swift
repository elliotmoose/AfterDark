import UIKit
class Bar{
    var name : String
    var ID : String
    var icon: UIImage?
    var rating = Rating()
    var reviews = [Review]()
    var discounts = [Discount]()
    var Images: [UIImage] = []
    var maxImageCount = -1
    var description : String = ""
    var contact : String = ""
    var loc_long : Float = 0
    var loc_lat : Float = 0
    var openClosingHours:String?
    var bookingAvailable: String
    //rating
    
    init()
    {
        name = "Untitled"
        contact = ""
        openClosingHours = ""
        ID = ""
        bookingAvailable = "0"
    }
    
    
    
}
