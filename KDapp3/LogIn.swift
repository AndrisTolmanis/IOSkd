import UIKit
import Firebase

class LogIn: UIViewController {
    @IBOutlet var txtLoginEmail: UITextField!
    @IBOutlet var txtLoginPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func btnSignInClick(_ sender: UIButton) {
        let email:String = txtLoginEmail.text as! String
        let password:String = txtLoginPass.text as! String
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if error != nil {
                self?.showToast(message: "Sign In failed")
                return
            } else {
                
                self?.showToast(message: "Sign In Success")
                self?.performSegue(withIdentifier: "signedin", sender: nil)
            }
        }
    }
}
