import UIKit

class PaydayDetailCellA2: UITableViewCell {
    
    @IBOutlet weak var dailyChoresNumber: UILabel!
    @IBOutlet weak var jobConsistencyBonusNumber: UILabel!
    @IBOutlet weak var previousUnpaidAmountsNumber: UILabel!
    @IBOutlet weak var dailyChoresSubtotalNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
