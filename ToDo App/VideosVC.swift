import UIKit

class VideosVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let trainingVideos = ["bedrooms",
                               "bathrooms: toilets, sinks, & floors",
                               "laundry",
                               "vacuuming",
                               "wiping the table",
                               "kitchen counters",
                               "dishes","sweeping",
                               "car wash",
                               "dirty diapers",
                               "mopping",
                               "toilet training"]
    
    let setupVideos = ["setup",
                       "step 1",
                       "step 2 (part one)",
                       "step 2 (part two)",
                       "step 3 (part one)",
                       "step 3 (part two)",
                       "step 3 (consistency bonus)",
                       "step 4",
                       "step 4 (doing payday)",
                       "step 5",
                       "step 5 (directed spending)"]
    
    let miscVideos = ["How The Moneypants Solution helps prevent anger",
                      "Moneypants Boss",
                      "Fancy Foods & Treats"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addNavBarImage()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return trainingVideos.count
        } else if section == 1 {
            return setupVideos.count
        } else {
            return miscVideos.count
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! VideosCell
        cell.videoLabel.text = trainingVideos[indexPath.row]
        return cell
    }
    
    
    
    
    func addNavBarImage() {
        let navController = navigationController!
        let barImage = #imageLiteral(resourceName: "MPS logo white")
        let imageView = UIImageView(image: barImage)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - barImage.size.width / 2
        let bannerY = bannerHeight / 2 - barImage.size.height / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth * 0.75, height: bannerHeight * 0.75)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

}
