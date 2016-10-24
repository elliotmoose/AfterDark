import UIKit
class Bar{
    var name : String
    var icon: UIImage?
    var rating = Rating()
    var reviews = [Review]()
    var Images: [UIImage] = []
    var maxImageCount = -1
    var description : String = ""
    var loc_long : Float = 0
    var loc_lat : Float = 0
    //rating
    
    init()
    {
        name = "Untitled"
    }
    
    
    
}