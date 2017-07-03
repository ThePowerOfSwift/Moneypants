import UIKit

class Step5IncomeDetail: UIViewController {
    
    // ---------
    // Variables
    // ---------
    
    @IBOutlet weak var mowingLawns: UITextField!
    @IBOutlet weak var babysitting: UITextField!
    @IBOutlet weak var summerJobs: UITextField!
    @IBOutlet weak var paperRoute: UITextField!
    @IBOutlet weak var allOthers: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    var firstValue: Int = 0
    var secondValue: Int = 0
    var thirdValue: Int = 0
    var fourthValue: Int = 0
    var fifthValue: Int = 0
    var totalValue: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // ------------------------
    // text field editingDidEnd
    // ------------------------
    
    @IBAction func mowingLawnsEditingDidEnd(_ sender: UITextField) {
        totalLabel.text = "\(calculateTotal())"
    }
    
    @IBAction func babysittingEditingDidEnd(_ sender: UITextField) {
        totalLabel.text = "\(calculateTotal())"
    }
    
    @IBAction func summerJobsEditingDidEnd(_ sender: UITextField) {
        totalLabel.text = "\(calculateTotal())"
    }
    
    @IBAction func paperRouteEditingDidEnd(_ sender: UITextField) {
        totalLabel.text = "\(calculateTotal())"
    }
    
    @IBAction func allOtherEditingDidEnd(_ sender: UITextField) {
        totalLabel.text = "\(calculateTotal())"
    }
    
    
    
    // -------------------------------------------
    // func to calculate total of all input fields
    // -------------------------------------------
    
    func calculateTotal() -> Int {
        if mowingLawns.text != "" {
            firstValue = Int(mowingLawns.text!)!
        } else {
            firstValue = 0
        }
        if babysitting.text != "" {
            secondValue = Int(babysitting.text!)!
        } else {
            secondValue = 0
        }
        if summerJobs.text != "" {
            thirdValue = Int(summerJobs.text!)!
        } else {
            thirdValue = 0
        }
        if paperRoute.text != "" {
            fourthValue = Int(paperRoute.text!)!
        } else {
            fourthValue = 0
        }
        if allOthers.text != "" {
            fifthValue = Int(allOthers.text!)!
        } else {
            fifthValue = 0
        }
        return firstValue + secondValue + thirdValue + fourthValue + fifthValue
        
    }

    

}
