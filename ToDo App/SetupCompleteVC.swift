import UIKit
import Firebase

class SetupCompleteVC: UIViewController {
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if FamilyData.setupProgress <= 11 {
            FamilyData.setupProgress = 11
            ref.updateChildValues(["setupProgress" : 11])
        }
        performSegue(withIdentifier: "Done", sender: self)
    }
}
