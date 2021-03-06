import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var namePasswordView: UIView!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var questionMark: UILabel!
    @IBOutlet weak var plusSign: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namePasswordView.layer.cornerRadius = namePasswordView.bounds.height / 6.4
        namePasswordView.layer.masksToBounds = true
        namePasswordView.layer.borderWidth = 0.5
        namePasswordView.layer.borderColor = UIColor.lightGray.cgColor
        
        signinButton.layer.cornerRadius = signinButton.bounds.height / 6.4
        signinButton.layer.masksToBounds = true
        
        questionMark.layer.cornerRadius = questionMark.bounds.height / 2
        questionMark.layer.masksToBounds = true
        
        plusSign.layer.cornerRadius = plusSign.bounds.height / 2
        plusSign.layer.masksToBounds = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = Auth.auth().currentUser {
            self.signIn()
        }
    }
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
            guard let _ = user else {
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            self.showAlert("The user '\(email!)' was not found. Please try again, or tap 'new member' to create an account.")
                        case .wrongPassword:
                            self.showAlert("Incorrect username/password combination. Please try again.")
                        default:
                            self.showAlert("Error: \(error.localizedDescription)")
                        }
                    }
                    return
                }
                assertionFailure("user and error are nil")
                return
            }
            
            self.signIn()
        })
    }
    
    @IBAction func didRequestPasswordReset(_ sender: UIButton) {
        let prompt = UIAlertController(title: "Forgot Password", message: "Enter your account email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Please try again, or tap 'new member' to create an account.")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "The Moneypants Solution", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        performSegue(withIdentifier: "SignInFromLogin", sender: nil)
    }
    
}
