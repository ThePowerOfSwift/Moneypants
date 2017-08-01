import UIKit

class BudgetCell: UITableViewCell {
    
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var envelopeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
