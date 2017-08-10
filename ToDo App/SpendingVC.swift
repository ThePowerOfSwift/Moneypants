import UIKit

class SpendingVC: UIViewController {
    
    @IBOutlet weak var chooseCategoryButton: UIButton!
    
    let (userName, _, _) = tempUsers[homeIndex]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
        
        chooseCategoryButton.layer.cornerRadius = chooseCategoryButton.bounds.height / 6.4
        chooseCategoryButton.layer.masksToBounds = true
        chooseCategoryButton.layer.borderColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0).cgColor
        chooseCategoryButton.layer.borderWidth = 0.5
    }
    
    
    // -----------------
    // Navigation Segues
    // -----------------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseCategoryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowBudgetSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBudgetSegue" {
            let nextController = segue.destination as! MoneyVC
            nextController.navTop = 0
        }
    }
}
