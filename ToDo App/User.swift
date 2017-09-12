import Foundation
import UIKit

class User {
    
    var photo: UIImage
    var firstName: String
    var birthday: String
    var passcode: Int
    var gender: String
    var childParent: String
    
    init(profilePhoto: UIImage, userFirstName: String, userBirthday: String, userPasscode: Int, userGender: String, isUserChildOrParent: String) {
        
        self.photo = profilePhoto
        self.firstName = userFirstName
        self.birthday = userBirthday
        self.passcode = userPasscode
        self.gender = userGender
        self.childParent = isUserChildOrParent
        
    }
}


class FamilyMember {
    var name: String
    var photo: String
    
    init(nameText: String, photoUrlString: String) {
        name = nameText
        photo = photoUrlString

    }
}
