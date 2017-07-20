import UIKit

class IndividualMainVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ToHomeSegue", sender: self)
    }
    

}
