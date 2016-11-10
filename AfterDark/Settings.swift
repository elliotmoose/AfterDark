import Foundation
class Settings
{
    //test
    static let ignoreUserDefaults = true
    static let bypassLoginPage = true
    static let modelBarActive = true
    
    static let singleton = Settings()
    
    
    init()
    {
        self.LoadSettings()
    }

    func SaveSettings()
    {
        UserDefaults.standard.setValue(Account.singleton.user_name, forKey: "username")
    }

    func LoadSettings()
    {
        
    }


}
