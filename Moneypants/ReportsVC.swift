import UIKit

class ReportsVC: UIViewController {
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var budgetButton: UIButton!
    @IBOutlet weak var testingButton: UIButton!
    
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
        
        budgetButton.layer.cornerRadius = budgetButton.bounds.height / 6.4
        budgetButton.layer.masksToBounds = true
        budgetButton.layer.borderColor = UIColor.lightGray.cgColor
        budgetButton.layer.borderWidth = 0.5
        
        testingButton.layer.cornerRadius = testingButton.bounds.height / 6.4
        testingButton.layer.masksToBounds = true
        testingButton.layer.borderColor = UIColor.lightGray.cgColor
        testingButton.layer.borderWidth = 0.5
    }
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
