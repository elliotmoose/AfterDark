class : Settings
{
    static let singleton = Settings()
    var username: String
    var useremail : String
    var userID : Int
    
    func Initialize
    {
        self.LoadSettings()
    }
    func SaveSettings
    {
        NSUserDefaults.standardUserDefaults.SetString(self.username, forKey: "username")
    }

    func LoadSettings
    {
        
    }


}