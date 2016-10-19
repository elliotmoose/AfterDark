class : Settings
{
    static let singleton = Settings()
    
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