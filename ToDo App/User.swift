import Foundation
import UIKit
import Firebase

struct User {
    var photo: UIImage
    var firstName: String
    var birthday: Int
    var passcode: Int
    var gender: String
    var childParent: String
    
    static var finalUsersArray = [User]()
    
    static func loadMembers() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child(firebaseUser!.uid)
        ref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersCount = Int(snapshot.childrenCount)
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let birthday = value["birthday"] as! Int
                        let childParent = value["childParent"] as! String
                        let firstName = value["firstName"] as! String
                        let gender = value["gender"] as! String
                        let passcode = value["passcode"] as! Int
                        let profileImageUrl = value["profileImageUrl"] as! String
                        // get images
                        let storageRef = FIRStorage.storage().reference(forURL: profileImageUrl)
                        storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                            let pic = UIImage(data: data!)
                            let user = User(photo: pic!,
                                            firstName: firstName,
                                            birthday: birthday,
                                            passcode: passcode,
                                            gender: gender,
                                            childParent: childParent)
                            finalUsersArray.append(user)
                            
                            if usersCount == finalUsersArray.count {
                                print("Nice. There are",usersCount,"users in the snapshot, and there are",finalUsersArray.count,"users in the array")
                            }
                        })
                    }
                }
            }
        })
    }
}









