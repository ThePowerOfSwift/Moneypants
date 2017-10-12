import UIKit
import Firebase

class Step4PaydayInspectVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var paydayParentButton: UIButton!
    @IBOutlet weak var paydayDateButton: UIButton!
    @IBOutlet weak var paydayDateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var inspectionsParentButton: UIButton!
    @IBOutlet weak var inspectionsParentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var users = [UserClass]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paydayParentButton.isEnabled = false
        nextButton.isEnabled = false
        paydayDateTopConstraint.constant = -204
        inspectionsParentTopConstraint.constant = -160
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        loadParents { (usersArray) in
            self.users = usersArray
            print(self.users.count)
            for user in self.users {
                print(user.firstName)
            }
            self.paydayParentButton.isEnabled = true     // don't enable button until parents list has finished loading
        }
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func paydayParentButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A Parent", message: "Please choose a parent to hold weekly payday.", preferredStyle: .alert)
        for user in users {
            alert.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                self.paydayParentButton.setTitle(user.firstName, for: .normal)
                self.paydayParentButton.layer.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1.0).cgColor
                UIView.animate(withDuration: 0.25) {
                    self.paydayDateTopConstraint.constant = 0        // reveal next button
                    self.view.layoutIfNeeded()
                }
                let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
                
                // send selection to Firebase
                self.ref.child("paydayAndInspections").updateChildValues(["paydayParent" : user.firstName])
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func paydayDateButtonTapped(_ sender: UIButton) {
        paydayDateButton.layer.backgroundColor = UIColor(red: 0/2255, green: 153/255, blue: 255/255, alpha: 1.0).cgColor
        UIView.animate(withDuration: 0.25) {
            self.inspectionsParentTopConstraint.constant = 0     // reveal next button
            self.view.layoutIfNeeded()
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @IBAction func inspectionsParentButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A Parent", message: "Please choose which parent will be responsible for performing daily inspections.", preferredStyle: .alert)
        for user in users {
            alert.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                self.inspectionsParentButton.setTitle(user.firstName, for: .normal)
                self.inspectionsParentButton.layer.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1.0).cgColor
                self.nextButton.isEnabled = true
                
                // send selection to Firebase
                self.ref.child("paydayAndInspections").updateChildValues(["inspectionParent" : user.firstName])
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func loadParents(completion: @escaping ([UserClass]) -> ()) {
        var usersArray = [UserClass]()
        ref.child("members").queryOrdered(byChild: "childParent").queryEqual(toValue: "parent").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let birthday = value["birthday"] as! Int
                        let childParent = value["childParent"] as! String
                        let firstName = value["firstName"] as! String
                        let gender = value["gender"] as! String
                        let passcode = value["passcode"] as! Int
                        let profileImageUrl = value["profileImageUrl"] as! String
                        
                        let user = UserClass(userProfileImageURL: profileImageUrl, userFirstName: firstName, userBirthday: birthday, userPasscode: passcode, userGender: gender, isUserChildOrParent: childParent)
                        usersArray.append(user)
                    }
                }
            }
            completion(usersArray)
        }
    }
}







