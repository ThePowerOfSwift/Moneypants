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
    
    static var usersArray = [User]()
    
    static func loadMembers(completion: @escaping () -> ()) {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child(firebaseUser!.uid)
        ref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersCount = Int(snapshot.childrenCount)
            if usersCount == 0 {
                completion()
            } else {
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
                                usersArray.append(user)
                                usersArray.sort(by: {$0.birthday > $1.birthday})       // sort users by birthday with youngest first
                                
                                if usersArray.count == usersCount {
                                    completion()
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    static func gender(user: Int) -> (he_she: String, him_her: String, his_her: String) {
        var he_she: String!
        var him_her: String!
        var his_her: String!
        if User.usersArray[user].gender == "male" {
            he_she = "He"
            him_her = "Him"
            his_her = "His"
        } else {
            he_she = "She"
            him_her = "Her"
            his_her = "Her"
        }
        return (he_she, him_her, his_her)
    }
}









