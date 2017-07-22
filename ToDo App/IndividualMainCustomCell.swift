import UIKit

class IndividualMainCustomCell: UITableViewCell {
    
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var choreHabitLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    var count: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func choreHabitButtonTapped(_ sender: UIButton) {
        count += 1
        choreHabitLabel.textColor = UIColor.lightGray
        pointsLabel.textColor = UIColor.lightGray
        completionButton.setTitle("\(count)", for: .normal)
    }
    
    @IBAction func completionButtonTouchUpOutside(_ sender: UIButton) {
        count = 0
        choreHabitLabel.textColor = UIColor.black
        pointsLabel.textColor = UIColor.black
        completionButton.setTitle("", for: .normal)
    }
    
    
}
