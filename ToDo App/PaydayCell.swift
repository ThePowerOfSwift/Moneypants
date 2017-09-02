import UIKit

class PaydayCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var paidBadge: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the image with rounded corners
        userImage.layer.cornerRadius = userImage.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        paidBadge.layer.cornerRadius = paidBadge.bounds.height / 2
        paidBadge.layer.masksToBounds = true
        paidBadge.layer.borderWidth = 0.5
        paidBadge.layer.borderColor = UIColor.black.cgColor
    }
}
