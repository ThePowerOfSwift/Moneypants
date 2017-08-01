import UIKit

class HomeCustomCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userIncome: UILabel!
    @IBOutlet weak var earningsButton: UIButton!
    @IBOutlet weak var depositsButton: UIButton!
    @IBOutlet weak var feesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        earningsButton.layer.cornerRadius = earningsButton.layer.bounds.height / 2
//        earningsButton.layer.masksToBounds = true
//        earningsButton.layer.borderColor = UIColor.gray.cgColor
//        earningsButton.layer.borderWidth = 0.5
//        
//        depositsButton.layer.cornerRadius = depositsButton.layer.bounds.height / 2
//        depositsButton.layer.masksToBounds = true
//        depositsButton.layer.borderColor = UIColor.gray.cgColor
//        depositsButton.layer.borderWidth = 0.5
//
//        feesButton.layer.cornerRadius = feesButton.layer.bounds.height / 2
//        feesButton.layer.masksToBounds = true
//        feesButton.layer.borderColor = UIColor.gray.cgColor
//        feesButton.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
