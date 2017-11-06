import UIKit

class PaydayDetailCellC1: UITableViewCell {
    
    @IBOutlet weak var jobDesc: UILabel!
    @IBOutlet weak var tallyView: UIView!
    @IBOutlet weak var jobSubtotal: UILabel!
    @IBOutlet weak var tallyDay1: UILabel!
    @IBOutlet weak var tallyDay2: UILabel!
    @IBOutlet weak var tallyDay3: UILabel!
    @IBOutlet weak var tallyDay4: UILabel!
    @IBOutlet weak var tallyDay5: UILabel!
    @IBOutlet weak var tallyDay6: UILabel!
    @IBOutlet weak var tallyDay7: UILabel!

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
