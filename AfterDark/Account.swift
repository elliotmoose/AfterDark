class: Account
{
    static let singleton = Account()
    let urlLogin = "http://mooselliot.net23.net/Login.php"
    
    var user_name: String
    var user_ID :Int
    var user_Email : String
    
    func Login(username:String,password:String,(success:Bool)->Void)
    {
        let postParam =String("username=/(username)&password=/(password)")
        Network.DataFromUrlWithPost(urlLogin,postParam,{(success,output) -> Void in
        if let output = output
        {
            if output = "Login Success"
            {
                user_name = username
            }
        }
    })
}