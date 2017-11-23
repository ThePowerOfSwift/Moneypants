import UIKit

class PaydayDetailsPopupCell: UITableViewCell {
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemWeeklySubtotalLabel: UILabel!
    @IBOutlet weak var trophyImageView: UIImageView!
    
    @IBOutlet weak var dailyView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dailyView.isHidden = true
        
        dailyView.layer.cornerRadius = dailyView.bounds.height / 6.4
        dailyView.layer.masksToBounds = true
        dailyView.layer.borderColor = UIColor.lightGray.cgColor
        dailyView.layer.borderWidth = 0.5
        dailyView.backgroundColor = UIColor.white
    }
}
