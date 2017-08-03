import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var choreHabitLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
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
//        numberLabel.setTitle("\(number)", for: .normal)
    }
    
    @IBAction func completionButtonTouchUpOutside(_ sender: UIButton) {
        choreHabitLabel.textColor = UIColor.black
        pointsLabel.textColor = UIColor.black
//        numberLabel.setTitle("", for: .normal)
    }
    
    
}
