import UIKit
import Firebase

class Register: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass1: UITextField!
    @IBOutlet weak var txtPass2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // Register the user using magical Firebase functions
    @IBAction func btnRegisterClick(_ sender: Any) {
        let email:String = txtEmail.text as! String
        let password:String = txtPass1.text as! String
        let password2:String = txtPass2.text as! String
        if (password != password2){
            showToast(message: "Password mismatch")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.showToast(message: "Registration failed!")
                return
            } else {
                self.showToast(message: "Registration successful!")
            }
        }
    }
}

// Popup toasts like in android... yeah, I know... HERESY!
extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
