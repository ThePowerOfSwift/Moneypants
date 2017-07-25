import UIKit

class PaydayCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = userImage.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.borderWidth = 0.5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
