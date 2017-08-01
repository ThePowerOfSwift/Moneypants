import UIKit

class CBReportCell: UITableViewCell {
    
    @IBOutlet weak var choreHabitLabel: UILabel!
    @IBOutlet weak var choreHabitCBCount: UILabel!
    @IBOutlet weak var coloredBar: UIImageView!
    @IBOutlet weak var coloredBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var grayGrid: UIImageView!
    @IBOutlet weak var numberOfWeeksBox: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
