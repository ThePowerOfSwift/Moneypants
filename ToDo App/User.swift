import Foundation
import UIKit

class User {
    
    var photo: UIImage
    var firstName: String
    var birthday: Int
    var passcode: Int
    var gender: String
    var childParent: String
    
    init(profilePhoto: UIImage, userFirstName: String, userBirthday: Int, userPasscode: Int, userGender: String, isUserChildOrParent: String) {
        
        self.photo = profilePhoto
        self.firstName = userFirstName
        self.birthday = userBirthday
        self.passcode = userPasscode
        self.gender = userGender
        self.childParent = isUserChildOrParent
        
    }
}


// TESTING FUNCTION HERE
import Firebase

var finalUsersArray = [User]()
var firebaseUser: FIRUser!
var ref: FIRDatabaseReference!

func loadMembers() {
    firebaseUser = FIRAuth.auth()?.currentUser
    ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
    
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
                        let user = User(profilePhoto: pic!,
                                        userFirstName: firstName,
                                        userBirthday: birthday,
                                        userPasscode: passcode,
                                        userGender: gender,
                                        isUserChildOrParent: childParent)
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
