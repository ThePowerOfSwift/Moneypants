import UIKit

class PaydayDetailsPopupCell: UITableViewCell {
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemWeeklySubtotalLabel: UILabel!
    @IBOutlet weak var trophyImageView: UIImageView!
    
    @IBOutlet weak var dailyView: UIView!
    
    @IBOutlet weak var day1SLabel: UILabel!
    @IBOutlet weak var day2MLabel: UILabel!
    @IBOutlet weak var day3TLabel: UILabel!
    @IBOutlet weak var day4WLabel: UILabel!
    @IBOutlet weak var day5ThLabel: UILabel!
    @IBOutlet weak var day6FLabel: UILabel!
    @IBOutlet weak var day7SLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
