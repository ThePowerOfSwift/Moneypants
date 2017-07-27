import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var choreHabitLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
//    var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func choreHabitButtonTapped(_ sender: UIButton) {
//        self.buttonAction?(sender)
        
        choreHabitLabel.textColor = UIColor.lightGray
        pointsLabel.textColor = UIColor.lightGray
        completionButton.setTitle("1", for: .normal)
    }
    
    @IBAction func completionButtonTouchUpOutside(_ sender: UIButton) {
        choreHabitLabel.textColor = UIColor.black
        pointsLabel.textColor = UIColor.black
        completionButton.setTitle("", for: .normal)
    }
    
    
}
