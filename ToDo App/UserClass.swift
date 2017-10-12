import Foundation

// use this class as intermediate class when loading users for when you only need user info but not photos

class UserClass {
    
    var imageURL: String
    var firstName: String
    var birthday: Int
    var passcode: Int
    var gender: String
    var childParent: String
    
    init(userProfileImageURL: String, userFirstName: String, userBirthday: Int, userPasscode: Int, userGender: String, isUserChildOrParent: String) {
        
        self.imageURL = userProfileImageURL
        self.firstName = userFirstName
        self.birthday = userBirthday
        self.passcode = userPasscode
        self.gender = userGender
        self.childParent = isUserChildOrParent
    }
}




