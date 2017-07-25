import UIKit

class PaydayCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        expensesButton.layer.cornerRadius = expensesButton.bounds.height / 6.4
//        expensesButton.layer.masksToBounds = true
//        expensesButton.layer.borderColor = UIColor.black.cgColor
//        expensesButton.layer.borderWidth = 0.5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
