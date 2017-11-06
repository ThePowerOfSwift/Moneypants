import Foundation
import UIKit
import Firebase

struct MPUser {
    var photo: UIImage
    var firstName: String
    var birthday: Int
    var passcode: Int
    var gender: String
    var childParent: String
    
    static var usersArray = [MPUser]()
    static var currentUser: Int = 0
    
    static func loadMembers(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child(firebaseUser!.uid)
        ref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            let usersCount = Int(snapshot.childrenCount)
            if usersCount == 0 {
                completion()
            } else {
                for item in snapshot.children {
                    if let snap = item as? DataSnapshot {
                        if let value = snap.value as? [String : Any] {
                            let birthday = value["birthday"] as! Int
                            let childParent = value["childParent"] as! String
                            let firstName = value["firstName"] as! String
                            let gender = value["gender"] as! String
                            let passcode = value["passcode"] as! Int
                            let profileImageUrl = value["profileImageUrl"] as! String
                            // get images
                            let storageRef = Storage.storage().reference(forURL: profileImageUrl)
                            storageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                                let pic = UIImage(data: data!)
                                let user = MPUser(photo: pic!,
                                                  firstName: firstName,
                                                  birthday: birthday,
                                                  passcode: passcode,
                                                  gender: gender,
                                                  childParent: childParent)
                                usersArray.append(user)
                                usersArray.sort(by: {$0.birthday < $1.birthday})       // sort users by birthday with oldest first
                                
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
        if MPUser.usersArray[user].gender == "male" {
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









