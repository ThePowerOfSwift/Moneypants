import UIKit

class Step2Cell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        myImage.layer.cornerRadius = 75 / 6.4
        myImage.layer.masksToBounds = true
        myImage.layer.borderWidth = 0.5
        myImage.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
