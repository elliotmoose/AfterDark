import Foundation
class Account {
    
    static let singleton = Account()
    let urlLogin = "http://mooselliot.net23.net/Login.php"
    
    var user_name: String
    var user_ID :String
    var user_Email : String
    
    init() {
        user_name = ""
        user_ID = ""
        user_Email = ""
    }
    
    func Login(_ username:String,password:String,handler: (_ success:Bool)->Void)
    {
        let postParam = String("username=\(username)&password=\(password)")
        Network.singleton.DataFromUrlWithPost(urlLogin,postParam: postParam!,handler: {(success,output) -> Void in
            if let output = output
            {
                let outputString = String(describing: output)
                if outputString == "Login Success"
                {
                    self.user_name = username
                }
            else if outputString == "wrong pass"
            {
                
            }
            else if outputString == "invalid ID"
            {
                
            }
            }
        })
    }

	func Save()
	{
	    let UD = UserDefaults.standard
	    UD.setValue(user_name,forKey: "user_name")
	    UD.setValue(user_ID,forKey: "User_ID")
	    UD.setValue(user_Email,forKey: "User_Email")
	}

	func Load()
	{
		 let UD = UserDefaults.standard
		 self.user_name = UD.value(forKey: "user_name") as! String
		 self.user_ID = UD.value(forKey: "User_ID") as! String
		 self.user_Email = UD.value(forKey: "User_Email") as! String
	}
}
