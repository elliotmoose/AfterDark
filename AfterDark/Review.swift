struct Review{
    var rating: Rating = Rating()
    var title: String = ""
    var description: String = ""
    var user_name: String = ""
    var date: NSDate = NSDate()
    
    func init(dict: NSDictionary)
    {
        rating.InjectValues(dict["Rating_Avg"],dict["Rating_Price"],dict["Rating_Ambience"],dict["Rating_Food"],dict["Rating_Service"]
        self.title = dict["Review_Title"]
        self.description = dict["Review_Text"]
        self.user_name = dict["User_Name"]
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