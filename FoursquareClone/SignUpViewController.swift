import UIKit
import Parse

//Parse ayarlarını appdelegate içinden yapıyoruz

//Kullanıcı login olup olmadı kontrolünü SceneDelegate içinde yapıyoruz

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Banana"
        parseObject["calories"] = 150
        parseObject.saveInBackground { success, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else{
                print("uploaded")
            }
        }*/
        
        /*let query = PFQuery(className: "Fruits")
        //query.whereKey("name", equalTo: "Apple")
        //query.whereKey("calories", lessThan: 120)
        query.whereKey("calories", greaterThan: 120)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                print(objects)
            }
        }*/
    }


    @IBAction func signInClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "An error occured.")
                }
                else {
                    //Segue yapılacak
                    //print(user?.username)
                    //print(user?.objectId)
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        else {
            makeAlert(title: "Error", message: "Username or password error.")
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "An error occured.")
                }
                else {
                    //Segue yapılacak
                    //print("OK")
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        else {
            makeAlert(title: "Error", message: "Username or password error.")
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

