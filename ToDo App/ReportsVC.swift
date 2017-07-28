import UIKit

class ReportsVC: UIViewController {
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
        
        buttonOne.layer.cornerRadius = buttonOne.bounds.height / 6.4
        buttonOne.layer.masksToBounds = true
        buttonOne.layer.borderColor = UIColor.lightGray.cgColor
        buttonOne.layer.borderWidth = 0.5
        
        buttonTwo.layer.cornerRadius = buttonTwo.bounds.height / 6.4
        buttonTwo.layer.masksToBounds = true
        buttonTwo.layer.borderColor = UIColor.lightGray.cgColor
        buttonTwo.layer.borderWidth = 0.5

        buttonThree.layer.cornerRadius = buttonThree.bounds.height / 6.4
        buttonThree.layer.masksToBounds = true
        buttonThree.layer.borderColor = UIColor.lightGray.cgColor
        buttonThree.layer.borderWidth = 0.5
    }
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
