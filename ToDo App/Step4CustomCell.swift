import UIKit

class Step4CustomCell: UITableViewCell {
    
    @IBOutlet weak var choreLabel: UILabel!
    @IBOutlet weak var choreButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func choreButtonTapped(_ sender: UIButton) {
        if !choreButton.isSelected {
            choreButton.isSelected = true
            choreLabel.textColor = UIColor.lightGray
            print("chore selected")
        } else {
            choreButton.isSelected = false
            choreLabel.textColor = UIColor.black
            print("chore deselected")
        }
    }
    
}



