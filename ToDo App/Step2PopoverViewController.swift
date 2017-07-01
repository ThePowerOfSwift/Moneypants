import UIKit

class Step2PopoverViewController: UIViewController {
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
