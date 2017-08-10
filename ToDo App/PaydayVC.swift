import UIKit

class PaydayVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let (tempUserName, tempUserImage, _) = tempUsers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! PaydayCell
        cell.userImage.image = tempUserImage
        cell.userName.text = tempUserName
        
        // customize the image with rounded corners
        cell.userImage.layer.cornerRadius = cell.userImage.bounds.height / 6.4
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.borderWidth = 0.5
        cell.userImage.layer.borderColor = UIColor.black.cgColor
        
        cell.paidBadge.layer.cornerRadius = cell.paidBadge.bounds.height / 2
        cell.paidBadge.layer.masksToBounds = true
        cell.paidBadge.layer.borderWidth = 0.5
        cell.paidBadge.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeIndex = indexPath.row
        performSegue(withIdentifier: "DetailSegue", sender: self)
    }
}
