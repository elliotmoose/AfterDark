import Foundation

struct Review{
    var rating: Rating = Rating()
    var title: String = ""
    var description: String = ""
    var user_name: String = ""
    var date: NSDate = NSDate()
    
    mutating func initWithDict(dict : NSDictionary)
    {
        self.rating.InjectValues(dict["Rating_Avg"] as! Float,pricex: dict["Rating_Price"] as! Float,ambiencex: dict["Rating_Ambience"] as! Float,foodx: dict["Rating_Food"] as! Float,servicex: dict["Rating_Service"]as! Float)
        self.title = dict["Review_Title"] as! String
        self.description = dict["Review_Text"] as! String
        self.user_name = dict["User_Name"] as! String
        //set data
    }
    mutating func InjectValues(rate: Rating, descrip: String, username: String, datex: NSDate)
    {
        rating = rate
        description = descrip
        user_name = username
        date = datex
    }


    
    }