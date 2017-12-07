import UIKit

class PaydayVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var paidBadgeColorArray = [CGColor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        paidBadgeColorArray.removeAll()
        for user in MPUser.usersArray {
            let alreadyPaidIso = Points.pointsArray.filter({ $0.user == user.firstName &&
                $0.itemCategory == "payday" &&
                $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 &&
                $0.itemDate < FamilyData.calculatePayday().next.timeIntervalSince1970 })
            
            let paidTodayIso = Points.pointsArray.filter({ $0.user == user.firstName &&
                $0.itemCategory == "payday" &&
                Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            // if user hasn't been paid AND it's payday or later, turn badge red
            if alreadyPaidIso.isEmpty && Date() >= FamilyData.calculatePayday().current {
                paidBadgeColorArray.append(UIColor.red.cgColor)
            // if user has been paid today
            } else if !alreadyPaidIso.isEmpty && !paidTodayIso.isEmpty {
                paidBadgeColorArray.append(UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0).cgColor)
            } else {
                paidBadgeColorArray.append(UIColor.lightGray.cgColor)
            }
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MPUser.usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! PaydayCell
        cell.userName.text = MPUser.usersArray[indexPath.row].firstName
        cell.userImage.image = MPUser.usersArray[indexPath.row].photo
        cell.paidBadge.layer.backgroundColor = paidBadgeColorArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // if user has already been paid for the week, they can't be paid again
        let alreadyPaidIso = Points.pointsArray.filter({ $0.user == MPUser.usersArray[indexPath.row].firstName &&
            $0.itemCategory == "payday" &&
            $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 &&
            $0.itemDate < FamilyData.calculatePayday().next.timeIntervalSince1970 })
        
        if !alreadyPaidIso.isEmpty {
            let alert = UIAlertController(title: "Payday", message: "\(MPUser.usersArray[indexPath.row].firstName) has already been paid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            MPUser.currentUser = indexPath.row
            performSegue(withIdentifier: "PaydayDetail", sender: self)
        }
    }
}


