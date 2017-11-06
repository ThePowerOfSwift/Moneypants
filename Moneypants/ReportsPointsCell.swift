import UIKit

class ReportsPointsCell: UITableViewCell {
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var jobHabitLabel: UILabel!
    @IBOutlet weak var jobHabitPointValueLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
