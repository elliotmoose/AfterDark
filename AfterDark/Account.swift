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
    
    func Login(username:String,password:String,handler: (success:Bool)->Void)
    {
        let postParam = String("username=\(username)&password=\(password)")
        Network.singleton.DataFromUrlWithPost(urlLogin,postParam: postParam,handler: {(success,output) -> Void in
            if let output = output
            {
                if output == "Login Success"
                {
                    self.user_name = username
                }
            else if output == "wrong pass"
            {
                
            }
            else if output == "invalid ID"
            {
                
            }
            }
        })
    }

	func Save()
	{
	    let UD = NSUserDefaults.standardUserDefaults()
	    UD.setValue(user_name,forKey: "user_name")
	    UD.setValue(user_ID,forKey: "User_ID")
	    UD.setValue(user_Email,forKey: "User_Email")
	}

	func Load()
	{
		 let UD = NSUserDefaults.standardUserDefaults()
		 self.user_name = UD.valueForKey("user_name") as! String
		 self.user_ID = UD.valueForKey("User_ID") as! String
		 self.user_Email = UD.valueForKey("User_Email") as! String
	}
}