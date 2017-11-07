import UIKit
import Firebase

class SetupCompleteVC: UIViewController {
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if FamilyData.setupProgress <= 11 {
            FamilyData.setupProgress = 11
            ref.updateChildValues(["setupProgress" : 11])
        }
        performSegue(withIdentifier: "Done", sender: self)
    }
}
