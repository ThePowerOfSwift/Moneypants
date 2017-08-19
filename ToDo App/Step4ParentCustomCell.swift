import UIKit

class Step4ParentCustomCell: UITableViewCell {
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var jobButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func jobButtonTapped(_ sender: UIButton) {
        if !jobButton.isSelected {
            jobButton.isSelected = true
            jobLabel.textColor = UIColor.lightGray
            print("job selected")
        } else {
            jobButton.isSelected = false
            jobLabel.textColor = UIColor.black
            print("job deselected")
        }
    }
}
