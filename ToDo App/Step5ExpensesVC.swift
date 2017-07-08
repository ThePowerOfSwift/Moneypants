import UIKit

class Step5ExpensesVC: UIViewController {
    
    
    @IBOutlet weak var budgetTotal: UILabel!

    // clothing variables
    @IBOutlet weak var clothingView: UIView!
    @IBOutlet weak var clothingArrow: UIImageView!
    @IBOutlet weak var clothingTop: NSLayoutConstraint!
    @IBOutlet weak var clothingTotal: UILabel!
    @IBOutlet weak var clothing1: UITextField!
    @IBOutlet weak var clothing2: UITextField!
    @IBOutlet weak var clothing3: UITextField!
    @IBOutlet weak var clothing4: UITextField!
    @IBOutlet weak var clothing5: UITextField!
    @IBOutlet weak var clothing6: UITextField!
    @IBOutlet weak var clothing7: UITextField!
    
    // accessories variables
    @IBOutlet weak var accessoriesView: UIView!
    @IBOutlet weak var accessoriesArrow: UIImageView!
    @IBOutlet weak var accessoriesTop: NSLayoutConstraint!
    @IBOutlet weak var accessoriesTotal: UILabel!
    @IBOutlet weak var accessories1: UITextField!
    @IBOutlet weak var accessories2: UITextField!
    @IBOutlet weak var accessories3: UITextField!
    @IBOutlet weak var accessories4: UITextField!
    @IBOutlet weak var accessories5: UITextField!
    
    // grooming variables
    @IBOutlet weak var groomingView: UIView!
    @IBOutlet weak var groomingArrow: UIImageView!
    @IBOutlet weak var groomingTop: NSLayoutConstraint!
    @IBOutlet weak var groomingTotal: UILabel!
    @IBOutlet weak var grooming1: UITextField!
    @IBOutlet weak var grooming2: UITextField!
    @IBOutlet weak var grooming3: UITextField!
    @IBOutlet weak var grooming4: UITextField!
    @IBOutlet weak var grooming5: UITextField!
    @IBOutlet weak var grooming6: UITextField!
    
    // sports & dance variables
    @IBOutlet weak var sportsView: UIView!
    @IBOutlet weak var sportsArrow: UIImageView!
    @IBOutlet weak var sportsTop: NSLayoutConstraint!
    @IBOutlet weak var sportsTotal: UILabel!
    @IBOutlet weak var sports1: UITextField!
    @IBOutlet weak var sports2: UITextField!
    @IBOutlet weak var sports3: UITextField!
    @IBOutlet weak var sports4: UITextField!
    @IBOutlet weak var sports5: UITextField!
    @IBOutlet weak var sports6: UITextField!
    @IBOutlet weak var sports7: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clothingTop.constant = -(clothingView.bounds.height)        // set clothing view out of range to start
        clothingView.isHidden = true
        accessoriesTop.constant = -(accessoriesView.bounds.height)
        accessoriesView.isHidden = true
        groomingTop.constant = -(groomingView.bounds.height)
        groomingView.isHidden = true
        sportsTop.constant = -(sportsView.bounds.height)
        sportsView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ----------------
    // Clothing Actions
    // ----------------
    
    @IBAction func clothingButtonTapped(_ sender: UIButton) {
        if clothingTop.constant == -(clothingView.bounds.height) {
            revealTable(section: clothingView, arrow: clothingArrow, topConstraint: clothingTop)
        } else {
            hideTable(section: clothingView, arrow: clothingArrow, topConstraint: clothingTop)
        }
    }
    
    // NOTE: all clothing text fields are linked to this function via CTRL-drag (see storyboard connections for detail)
    @IBAction func clothing1EditingDidEnd(_ sender: UITextField) {
        let firstValue = Int(clothing1.text!) ?? 0
        let secondValue = Int(clothing2.text!) ?? 0
        let thirdValue = Int(clothing3.text!) ?? 0
        let fourthValue = Int(clothing4.text!) ?? 0
        let fifthValue = Int(clothing5.text!) ?? 0
        let sixthValue = Int(clothing6.text!) ?? 0
        let seventhValue = Int(clothing7.text!) ?? 0
        clothingTotal.text = "\(firstValue + secondValue + thirdValue + fourthValue + fifthValue + sixthValue + seventhValue)"
        budgetTotal.text = "\(calculateBudgetTotal())"
    }
    
    // -------------------
    // Accessories Actions
    // -------------------
    
    @IBAction func accessoriesButtonTapped(_ sender: UIButton) {
        if accessoriesTop.constant == -(accessoriesView.bounds.height) {
            revealTable(section: accessoriesView, arrow: accessoriesArrow, topConstraint: accessoriesTop)
        } else {
            hideTable(section: accessoriesView, arrow: accessoriesArrow, topConstraint: accessoriesTop)
        }
    }
    
    // accessories subtotal
    @IBAction func accessoriesEditingDidEnd(_ sender: UITextField) {
        let firstValue = Int(accessories1.text!) ?? 0
        let secondValue = Int(accessories2.text!) ?? 0
        let thirdValue = Int(accessories3.text!) ?? 0
        let fourthValue = Int(accessories4.text!) ?? 0
        let fifthValue = Int(accessories5.text!) ?? 0
        accessoriesTotal.text = "\(firstValue + secondValue + thirdValue + fourthValue + fifthValue)"
        budgetTotal.text = "\(calculateBudgetTotal())"
    }
    
    // ----------------
    // Grooming Actions
    // ----------------
    
    @IBAction func groomingButtonTapped(_ sender: UIButton) {
        if groomingTop.constant == -(groomingView.bounds.height) {
            revealTable(section: groomingView, arrow: groomingArrow, topConstraint: groomingTop)
        } else {
            hideTable(section: groomingView, arrow: groomingArrow, topConstraint: groomingTop)
        }
    }
    
    @IBAction func groomingEditingDidEnd(_ sender: UITextField) {
        let firstValue = Int(grooming1.text!) ?? 0
        let secondValue = Int(grooming2.text!) ?? 0
        let thirdValue = Int(grooming3.text!) ?? 0
        let fourthValue = Int(grooming4.text!) ?? 0
        let fifthValue = Int(grooming5.text!) ?? 0
        let sixthValue = Int(grooming6.text!) ?? 0
        groomingTotal.text = "\(firstValue + secondValue + thirdValue + fourthValue + fifthValue + sixthValue)"
        budgetTotal.text = "\(calculateBudgetTotal())"
    }
    
    // ----------------------
    // Sports & Dance Actions
    // ----------------------
    
    @IBAction func sportsButtonTapped(_ sender: UIButton) {
        if sportsTop.constant == -(sportsView.bounds.height) {
            revealTable(section: sportsView, arrow: sportsArrow, topConstraint: sportsTop)
        } else {
            hideTable(section: sportsView, arrow: sportsArrow, topConstraint: sportsTop)
        }
    }
    
    @IBAction func sportsEditingDidEnd(_ sender: UITextField) {
        let firstValue = Int(sports1.text!) ?? 0
        let secondValue = Int(sports2.text!) ?? 0
        let thirdValue = Int(sports3.text!) ?? 0
        let fourthValue = Int(sports4.text!) ?? 0
        let fifthValue = Int(sports5.text!) ?? 0
        let sixthValue = Int(sports6.text!) ?? 0
        let seventhValue = Int(sports7.text!) ?? 0
        sportsTotal.text = "\(firstValue + secondValue + thirdValue + fourthValue + fifthValue + sixthValue + seventhValue)"
        budgetTotal.text = "\(calculateBudgetTotal())"
    }
    
    
   
    
    // -------------------------
    // Table Animation Templates
    // -------------------------

    func revealTable(section: UIView, arrow: UIImageView, topConstraint: NSLayoutConstraint) {
        // rotate the right arrow down
        section.isHidden = false
        // rotate the arrown down
        UIView.animate(withDuration: 0.25) {
            arrow.transform = CGAffineTransform(rotationAngle: (90.0 * .pi) / 180.0)
        }
        // show the table
        UIView.animate(withDuration: 0.5, animations: {
            topConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }

    func hideTable(section: UIView, arrow: UIImageView, topConstraint: NSLayoutConstraint) {
        // rotate the right arrow back up
        UIView.animate(withDuration: 0.25) {
            arrow.transform = CGAffineTransform(rotationAngle: (0 * .pi) / 180.0)
        }
        // hide the table from view
        UIView.animate(withDuration: 0.5, animations: {
            topConstraint.constant = -(section.bounds.height)
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            section.isHidden = true
        }
    }
    
    // --------------------------
    // Table Calcualtion Template
    // --------------------------
    
    func calculateBudgetTotal () -> Int {
        let firstTotal = Int(clothingTotal.text!) ?? 0
        let secondTotal = Int(accessoriesTotal.text!) ?? 0
        let thirdTotal = Int(groomingTotal.text!) ?? 0
        let fourthTotal = Int(sportsTotal.text!) ?? 0
        return firstTotal + secondTotal + thirdTotal + fourthTotal
    }
    

}





















