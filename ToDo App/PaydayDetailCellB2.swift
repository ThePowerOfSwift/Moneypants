import UIKit

class PaydayDetailCellB2: UITableViewCell {
    
    @IBOutlet weak var dailyHabitsNumber: UILabel!
    @IBOutlet weak var habitConsistencyBonusNumber: UILabel!
    @IBOutlet weak var previousUnpaidAmountsNumber: UILabel!
    @IBOutlet weak var dailyHabitsSubtotalNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
