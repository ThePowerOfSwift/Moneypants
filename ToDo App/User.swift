import Foundation
import UIKit

class User {
    
    var photo: UIImage
    var firstName: String
    var birthday: String
    var passcode: Int
    var gender: String
    var childParent: String
    
    init(photo: UIImage, firstName: String, birthday: String, passcode: Int, gender: String, childParent: String) {
        
        self.photo = photo
        self.firstName = firstName
        self.birthday = birthday
        self.passcode = passcode
        self.gender = gender
        self.childParent = childParent
        
    }
}
