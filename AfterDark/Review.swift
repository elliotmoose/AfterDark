import Foundation

struct Review{
    var rating: Rating = Rating()
    var title: String = ""
    var description: String = ""
    var user_name: String = ""
    var date: NSDate = NSDate()
    
    mutating func initWithDict(dict : NSDictionary)
    {
        let Rating_Avg = Float(dict["Rating_Avg"] as! String)
        let Rating_Price = Float(dict["Rating_Price"] as! String)
        let Rating_Ambience = Float(dict["Rating_Ambience"] as! String)
        let Rating_Food = Float(dict["Rating_Food"] as! String)
        let Rating_Service = Float(dict["Rating_Service"] as! String)

        self.rating.InjectValues(Rating_Avg!,pricex: Rating_Price!,ambiencex: Rating_Ambience!,foodx: Rating_Food!,servicex: Rating_Service!)
        self.title = dict["Review_Title"] as! String
        self.description = dict["Review_Text"] as! String
        self.user_name = dict["User_Name"] as! String
        //set data
    }
    mutating func InjectValues(rate: Rating, descrip: String, username: String
        , datex: NSDate)
    {
        rating = rate
        description = descrip
        user_name = username
        date = datex
    }


    
    }