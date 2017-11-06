import UIKit

class Step4CustomCell: UITableViewCell {
    
    @IBOutlet weak var jobLabel: UILabel!    
    @IBOutlet weak var selectionBoxImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}



