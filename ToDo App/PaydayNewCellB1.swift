import UIKit

class PaydayNewCellB1: UITableViewCell {

    @IBOutlet weak var jobDesc: UILabel!
    @IBOutlet weak var tallyView: UIView!
    @IBOutlet weak var jobSubtotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tallyView.layer.cornerRadius = tallyView.bounds.height / 6.4
        tallyView.layer.masksToBounds = true
        tallyView.layer.borderColor = UIColor.lightGray.cgColor
        tallyView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
