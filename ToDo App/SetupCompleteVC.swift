import UIKit

class SetupCompleteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomePage") as! HomeVC
        self.present(newViewController, animated: true, completion: nil)
    }
    

}
