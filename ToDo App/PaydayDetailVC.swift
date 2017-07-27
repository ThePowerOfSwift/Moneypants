import UIKit

class PaydayDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var incomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (userName, _, userIncome) = tempUsers[paydayIndex]
//        nameLabel.text = userName
//        imageView.image = userImage
        incomeLabel.text = userIncome
        
        self.navigationItem.title = userName
    }
}
