import Foundation
class Account {
    
    
    static let singleton = Account()
    var user_name: String?
    var user_ID :String?
    var user_Email : String?
    
    init() {

        
    }
    

    func Login(_ username:String,password:String,handler: @escaping (_ success:Bool,_ resultString : String)->Void)
    {
        let urlLogin = Network.domain + "Login.php"
        let postParam = String("username=\(username)&password=\(password)")
        
        Network.singleton.DataFromUrlWithPost(urlLogin,postParam: postParam!,handler: {(success,output) -> Void in
            if let output = output
            {
                
                let mutableOut = (output as NSData).mutableCopy() as! NSMutableData

                //output here is a dict array
                let array = Network.JsonDataToDictArray(mutableOut)
                let dict = array[0] 
                
                
                let outputString = dict["result"] as! String
                if outputString == "Login Success"
                {
                    self.user_name = dict["User_Name"] as? String
                    self.user_Email = dict["User_Email"] as? String
                    self.user_ID = dict["User_ID"] as? String

                    self.Save()
                    
                    handler(true,"Login Success")
                }
                else if outputString == "Invalid Password"
                {
                    handler(false,"Invalid Password")
                }
                else if outputString == "Invalid ID"
                {
                    handler(false,"Invalid Username")
                }
                
            }
            else
            {
                 handler(false,"Can't connect to server")
            }
        })
    }

    func CreateNewAccount(_ username: String, _ password: String, _ email: String, _ dateOfBirth : String, handler: @escaping (_ success : Bool, _ response: String)-> Void)
    {
        let postParam = "username=\(username)&password=\(password)&email=\(email)&DOB=\(dateOfBirth)"
        let urlCreateAccount = Network.domain + "CreateAccount.php"
        
        Network.singleton.StringFromUrlWithPost(urlCreateAccount,postParam: postParam,handler: {(success,output) -> Void in
        
            if let output = output
            {
                if output == "Create Account successful"
                {
                    handler(true, "Your account is ready")
                }
                else if output == "Username taken"
                {
                    handler(false, "Username taken")
                }
                else if output == "Email already in use"
                {
                    handler(false, "Email already in use")
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
        if Settings.ignoreUserDefaults == false
        {
            
            let UD = UserDefaults.standard
            
            self.user_name = UD.value(forKey: "user_name") as? String
            
            self.user_ID = UD.value(forKey: "User_ID") as? String
            self.user_Email = UD.value(forKey: "User_Email") as? String
        }
	}
}
