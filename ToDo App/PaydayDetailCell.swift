import UIKit

class PaydayDetailCell: UITableViewCell {
    
    @IBOutlet weak var choreHabitDesc: UILabel!
    @IBOutlet weak var tallyView: UIView!
    @IBOutlet weak var choreHabitTotal: UILabel!
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab3: UILabel!
    @IBOutlet weak var lab4: UILabel!
    @IBOutlet weak var lab5: UILabel!
    @IBOutlet weak var lab6: UILabel!
    @IBOutlet weak var lab7: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
