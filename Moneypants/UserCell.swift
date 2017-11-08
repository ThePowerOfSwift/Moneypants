import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var jobHabitLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var selectionBoxLabel: UILabel!
    @IBOutlet weak var selectionBoxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
