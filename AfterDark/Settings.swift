import Foundation
class Settings
{
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
