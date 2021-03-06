import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var newUserView: UIView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUserView.layer.cornerRadius = newUserView.bounds.height / 6.4
        newUserView.layer.masksToBounds = true
        newUserView.layer.borderWidth = 0.5
        newUserView.layer.borderColor = UIColor.lightGray.cgColor
        
        createAccountButton.layer.cornerRadius = createAccountButton.bounds.height / 6.4
        createAccountButton.layer.masksToBounds = true
        
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .emailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            let newUserReference = Database.database().reference().child("users").child((user?.uid)!)
            newUserReference.setValue(["email" : self.emailField.text])
            self.signIn()
        })
    }
    
    @IBAction func didTapBackToLogin(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {})
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "The Moneypants Solution", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
    }
    
}
