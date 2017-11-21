import UIKit

class PaydayDetailVC2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
//    @IBOutlet weak var totalEarningsLabel: UILabel!
    
    let paydayImages = ["broom white", "music white", "lawnmower white", "broom plus white", "dollar minus white", "shopping cart small white", "dollar white"]
    let paydayTitles = ["daily jobs", "daily habits", "weekly jobs", "other jobs", "fees", "withdrawals", "unpaid earn"]
    let tempAmounts = [13.58, 9.12, 5.15, 3.03, 0.71, 0.71, 3.03]
    
    var currentUserName: String!
    var currentUserIncome: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName
        
        currentUserIncome = Income.currentIncomeArray.filter({ $0.user == currentUserName }).first?.currentPoints
//        totalEarningsLabel.text = "$\(String(format: "%.2f", Double(currentUserIncome!) / 100))"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paydayImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PaydayDetailCellD1
        cell.myImageView.image = UIImage(named: paydayImages[indexPath.row])
        return cell
    }
}
