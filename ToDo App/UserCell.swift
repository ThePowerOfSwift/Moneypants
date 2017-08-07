import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var choreHabitLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var choreHabitButton: UIButton!
    
    var number = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func choreHabitButtonTapped(_ sender: UIButton) {
        number += 1
        choreHabitLabel.textColor = UIColor.lightGray
        pointsLabel.textColor = UIColor.lightGray
        counterLabel.text = "\(number)"
        print(number)
    }
    
    @IBAction func completionButtonTouchUpOutside(_ sender: UIButton) {
        number = 0
        choreHabitLabel.textColor = UIColor.black
        pointsLabel.textColor = UIColor.black
        counterLabel.text = "\(number)"
    }
}
