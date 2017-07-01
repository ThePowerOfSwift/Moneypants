import UIKit

class Step4HabitCustomCell: UITableViewCell {
    
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var habitButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func habitButtonTapped(_ sender: UIButton) {
        if !habitButton.isSelected {
            habitButton.isSelected = true
            habitLabel.textColor = UIColor.lightGray
            print("habit selected")
        } else {
            habitButton.isSelected = false
            habitLabel.textColor = UIColor.black
            print("habit deselected")
        }
    }

}
