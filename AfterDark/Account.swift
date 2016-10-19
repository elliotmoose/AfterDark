class Account {
    
    static let singleton = Account()
    let urlLogin = "http://mooselliot.net23.net/Login.php"
    
    var user_name: String
    var user_ID :Int
    var user_Email : String
    
    init() {
        user_name = ""
        user_ID = 0
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
            }
        })
    }
}