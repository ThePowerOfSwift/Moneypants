import UIKit

class TransactionsCell: UITableViewCell {
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var choreHabitLabel: UILabel!
    @IBOutlet weak var choreHabitPointValueLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
