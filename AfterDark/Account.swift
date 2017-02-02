import Foundation

protocol LoggedInEventDelegate : class {
    func hasLoggedIn()
}

class Account {
    
    
    static let singleton = Account()
    var user_name: String?
    var user_ID :String?
    var user_Email : String?
    var user_loyaltyPts : String?
    weak var delegate : LoggedInEventDelegate?
    
    init() {

        
    }
    

    func Login(_ username:String,password:String,handler: @escaping (_ success:Bool,_ resultString : String)->Void)
    {
        let urlLogin = Network.domain + "Login.php"
        let postParam = String("username=\(username.AddPercentEncodingForURL(plusForSpace: true)!)&password=\(password.AddPercentEncodingForURL(plusForSpace: true)!)")
        
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
                                    self.LoadAccountFromDict(userDetails)
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        handler(false,"Server Fault")
                                        return
                                    }
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
                                    
                                    if detail == "Invalid Username"
                                    {
                                        DispatchQueue.main.async {
                                            handler(false,"Invalid Username")
                                        }
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        handler(false,"Server Fault")
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
                    print("Cant log in : \(error)" )
                }

                
            }
            else
            {                
                DispatchQueue.main.async {
                    handler(false,"Check connection")
                }
            }
        })
    }
    
    
    func RefreshAccountInfo(_ handler : (()->Void)?)
    {
        
        guard let userID = user_ID else {NSLog("no user ID");return}
        
        let url = Network.domain + "HardLoadAccountInfo.php?User_ID=\(userID)"
        Network.singleton.DataFromUrl(url) { (success, output) in
            if success
            {
                if let output = output
                {
                    do
                    {
                        if let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? NSDictionary
                        {
                            if let succ = dict["success"] as? String
                            {
                                
                                
                                if succ == "true"
                                {
                                    guard let accountDict = dict["detail"] as? NSDictionary else {return}
                                    
                                    self.LoadAccountFromDict(accountDict)
                                    
                                    if let handler = handler
                                    {
                                        handler()
                                    }
                                    
                                    return
                                }
                                else if succ == "false"
                                {
                                    guard let detail = dict["detail"] as? String else {return}
                                    NSLog(detail)
                                }
                                
                            }
                            else
                            {
                                NSLog("invalid server response format")
                            }
                        }
                        else
                        {
                            NSLog("invalid server response format")
                        }
                        
                    }
                    catch
                    {
                        NSLog("invalid server response format")
                    }
                }
                else
                {
                    NSLog("no server response")
                }
            }
            else
            {
                PopupManager.singleton.GlobalPopup(title: "ERROR", body: "Check connection")
            }
            
            //if it falls through, means it failed
            if let handler = handler
            {
                handler()
            }
        }
        
        
    }

    func CreateNewAccount(_ firstname: String, _ lastname : String, _ gender : String, _ phone : String, _ username: String, _ password: String, _ email: String, _ dateOfBirth : String, handler: @escaping (_ success : Bool, _ response: String, _ dictOut : NSDictionary?)-> Void)
    {
        let paramFirstname = firstname.AddPercentEncodingForURL(plusForSpace: true)!
        let paramLastname = lastname.AddPercentEncodingForURL(plusForSpace: true)!
        let paramGender = gender.AddPercentEncodingForURL(plusForSpace: true)!
        let paramPhone = phone.AddPercentEncodingForURL(plusForSpace: true)!
        let paramUsername = username.AddPercentEncodingForURL(plusForSpace: true)!
        let paramPassword = password.AddPercentEncodingForURL(plusForSpace: true)!
        let paramEmail = email.AddPercentEncodingForURL(plusForSpace: true)!
        let paramDOB = dateOfBirth.AddPercentEncodingForURL(plusForSpace: true)!
        
        
        let postParam = "firstname=\(paramFirstname)&lastname=\(paramLastname)&gender=\(paramGender)&phone=\(paramPhone)&username=\(paramUsername)&password=\(paramPassword)&email=\(paramEmail)&DOB=\(paramDOB)"
        let urlCreateAccount = Network.domain + "AddNewAccount.php"
        
        Network.singleton.DataFromUrlWithPost(urlCreateAccount,postParam: postParam,handler: {(success,output) -> Void in
        
            if let output = output
            {

                do
                {
                    if let dict = try JSONSerialization.jsonObject(with: output, options: .allowFragments) as? NSDictionary
                    {
                        if let successful = dict["success"] as? String
                        {
                            if successful == "false"
                            {
                                let errorMessage = dict["detail"] as! String
                                DispatchQueue.main.async {
                                    handler(false,errorMessage,nil)
                                }
                                return
                            }
                            else if successful == "true"
                            {
                                if let outputDict = dict["detail"] as? NSDictionary
                                {
                                    DispatchQueue.main.async {
                                        handler(true,"Account created",outputDict)
                                    }
                                    return
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        handler(false,"Invalid server response",nil)
                                    }
                                    return
                                }
                                
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                handler(false,"Invalid server response",nil)
                            }
                            return
                        }

                    }

                }
                catch let _ as NSError
                {
                    DispatchQueue.main.async {
                        let outString = String(data: output, encoding: .utf8)
                        handler(false,"Invalid server response: \(outString!)" ,nil)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    let outString = String(data: output, encoding: .utf8)
                    handler(false,"Invalid server response: \(outString!)" ,nil)
                }
                return
                
               
            }
            else
            {
                DispatchQueue.main.async {
                    handler(false,"No server repsonse. Check connection",nil)
                }
            }
        
        })
    }
    
    func LoadAccountFromDict(_ dict : NSDictionary)
    {
        if let username = dict["User_Name"] as? String
        {
            self.user_name = username
        }
        
        if let email = dict["User_Email"] as? String
        {
            self.user_Email = email
        }
        
        if let loyaltyPts = dict["User_LoyaltyPts"] as? String
        {
            self.user_loyaltyPts = loyaltyPts
        }
        else if let loyaltyPts = dict["User_LoyaltyPts"] as? Int
        {
            self.user_loyaltyPts = "\(loyaltyPts)"
        }
        
        if let userID = dict["User_ID"] as? Int
        {
            self.user_ID = "\(userID)"
        }
        else if let userID = dict["User_ID"] as? String
        {
            self.user_ID = userID
        }
    }
    func LogOut()
    {
        let UD = UserDefaults.standard
        
        user_name = ""
        user_ID = ""
        user_Email = ""
        user_loyaltyPts = ""
        
        
        UD.setValue("",forKey: "user_name")
        UD.setValue("",forKey: "User_ID")
        UD.setValue("",forKey: "User_Email")
        UD.setValue(user_loyaltyPts,forKey: "Loyalty_Pts")
    }
    
	func Save()
	{
	    let UD = UserDefaults.standard
	    UD.setValue(user_name,forKey: "user_name")
	    UD.setValue(user_ID,forKey: "User_ID")
	    UD.setValue(user_Email,forKey: "User_Email")
        UD.setValue(user_loyaltyPts,forKey: "Loyalty_Pts")
	}

	func Load()
	{
        if Settings.ignoreUserDefaults == false
        {
            
            let UD = UserDefaults.standard
            
            self.user_name = UD.value(forKey: "user_name") as? String
            self.user_ID = UD.value(forKey: "User_ID") as? String
            self.user_Email = UD.value(forKey: "User_Email") as? String
            self.user_loyaltyPts = UD.value(forKey: "Loyalty_Pts") as? String
            
            if self.user_ID == nil || self.user_name == nil || self.user_Email == nil || self.user_loyaltyPts == nil
            {
                //push login screen
                self.user_name = ""
                self.user_ID = ""
                self.user_Email = ""
                self.user_loyaltyPts = ""
            }
            
            
        }
	}
}
