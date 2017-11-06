import UIKit

class ReportsCBCell: UITableViewCell {
    
    @IBOutlet weak var jobHabitLabel: UILabel!
    @IBOutlet weak var jobHabitCBCount: UILabel!
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
