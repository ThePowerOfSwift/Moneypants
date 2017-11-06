import UIKit

class Step6JobSummaryCell: UITableViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerImage.layer.cornerRadius = headerImage.bounds.height / 6.4
        headerImage.layer.masksToBounds = true
        headerImage.layer.borderWidth = 0.5
        headerImage.layer.borderColor = UIColor.black.cgColor
    }
}
