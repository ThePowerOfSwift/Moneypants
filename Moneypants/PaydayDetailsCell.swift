import UIKit

class PaydayDetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImageView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the image with rounded corners
        bgImageView.layer.cornerRadius = bgImageView.layer.bounds.height / 6.4
        bgImageView.layer.masksToBounds = true
        bgImageView.layer.borderColor = UIColor.black.cgColor
        bgImageView.layer.borderWidth = 0.5
    }
}
