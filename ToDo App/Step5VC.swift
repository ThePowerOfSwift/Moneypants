import UIKit

class Step5VC: UIViewController {
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func yesButtonTapped(_ sender: UIButton) {
        yesButton.isSelected = true
        noButton.isSelected = false
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        noButton.isSelected = true
        yesButton.isSelected = false
    }

    // ----------------------------------------
    // perform segue based off of 'yes' or 'no'
    // ----------------------------------------
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if yesButton.isSelected {
            performSegue(withIdentifier: "IncomeDetailSegue", sender: self)
        } else {
            performSegue(withIdentifier: "NoOutsideIncomeSegue", sender: self)
        }
    }
}
