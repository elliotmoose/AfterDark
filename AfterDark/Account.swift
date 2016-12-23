import Foundation

protocol LoggedInEventDelegate : class {
    func hasLoggedIn()
}

class Account {
    
    
    static let singleton = Account()
    var user_name: String?
    var user_ID :String?
    var user_Email : String?
    
    weak var delegate : LoggedInEventDelegate?
    
    init() {

        
    }
    

    func Login(_ username:String,password:String,handler: @escaping (_ success:Bool,_ resultString : String)->Void)
    {
        let urlLogin = Network.domain + "Login.php"
        let postParam = String("username=\(username)&password=\(password)")
        
        Network.singleton.DataFromUrlWithPost(urlLogin,postParam: postParam!,handler: {(success,output) -> Void in
            if let output = output
            {
                do
                {
                    if let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? NSDictionary
                    {
                        if let success = dict["success"] as? String
                        {
                            if success == "true"
                            {
                                if let userDetails = dict["detail"] as? NSDictionary
                                {
                                    self.user_name = userDetails["User_Name"] as? String
                                    self.user_Email = userDetails["User_Email"] as? String
                                    self.user_ID = userDetails["User_ID"] as? String
                                }
                                
                                self.Save()
                                
                                DispatchQueue.main.async {
                                    handler(true,"Login Success")
                                    self.delegate?.hasLoggedIn()
                                }
                            }
                            else
                            {
                                if let detail = dict["detail"] as? String
                                {
                                    if detail == "Invalid Password"
                                    {
                                        DispatchQueue.main.async {
                                            handler(false,"Invalid Password")
                                        }
                                    }
                                    
                                    if detail == "Invalid ID"
                                    {
                                        DispatchQueue.main.async {
                                            handler(false,"Invalid Username")
                                        }
                                    }
                                }
                                
                            }
                        }
                        else
                        {
                            NSLog("Cant log in,check connection")
                            
                        }
                    }
                }
                catch let error as NSError
                {
                    print(error)
                }

                
            }
            else
            {
                DispatchQueue.main.async {
                    handler(false,"Can't connect to server")
                }
            }
        })
    }

    func CreateNewAccount(_ username: String, _ password: String, _ email: String, _ dateOfBirth : String, handler: @escaping (_ success : Bool, _ response: String, _ dictOut : NSDictionary)-> Void)
    {

        
        
        
        let postParam = "username=\(username)&password=\(password)&email=\(email)&DOB=\(dateOfBirth)"
        let urlCreateAccount = Network.domain + "AddNewAccount.php"
        
        Network.singleton.DataFromUrlWithPost(urlCreateAccount,postParam: postParam,handler: {(success,output) -> Void in
        
            if let output = output
            {
                let jsonData = (output as NSData).mutableCopy() as! NSMutableData
                
//                let stringData = String(data: jsonData as Data, encoding: .utf8)
//                NSLog(stringData!)
                
                let dict = Network.JsonDataToDict(jsonData)
                
                if dict["success"] as! String == "false"
                {
                    let errorMessage = dict["detail"] as! String
                    DispatchQueue.main.async {
                        handler(false,errorMessage,dict)
                    }
                }
                
                if dict["success"] as! String == "true"
                {
                    DispatchQueue.main.async {
                        handler(true,"Account created",dict)
                    }
                    
                }
            }
        
        })
    }
    
    func LogOut()
    {
        let UD = UserDefaults.standard
        
        user_name = ""
        user_ID = ""
        user_Email = ""
        
        UD.setValue("",forKey: "user_name")
        UD.setValue("",forKey: "User_ID")
        UD.setValue("",forKey: "User_Email")
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
        if Settings.ignoreUserDefaults == false
        {
            
            let UD = UserDefaults.standard
            
            self.user_name = UD.value(forKey: "user_name") as? String
            self.user_ID = UD.value(forKey: "User_ID") as? String
            self.user_Email = UD.value(forKey: "User_Email") as? String
            
            if self.user_ID == nil || self.user_name == nil || self.user_Email == nil
            {
                //push login screen
                self.user_name = ""
                self.user_ID = ""
                self.user_Email = ""
                
            }
            
        }
	}
}
