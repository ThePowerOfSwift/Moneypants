import UIKit
import AVKit

class VideosVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let trainingVideos = ["bedrooms",
                          "bathrooms: toilets, sinks, & floors",
                          "laundry",
                          "vacuuming",
                          "wiping the table",
                          "kitchen counters",
                          "dishes",
                          "sweeping",
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
    
    let miscVideos = [("How The Moneypants Solution helps prevent anger", "https://vimeo.com/153579716"),
                      ("Moneypants Boss", "https://vimeo.com/153579716"),
                      ("Fancy Foods & Treats", "https://vimeo.com/153579716")]
    
    // refresh table view after user taps, so cells don't stay selected
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addNavBarImage()

    }
    
    // ----------------
    // Setup Table View
    // ----------------

    
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "training videos"
        } else if section == 1 {
            return "setup videos"
        } else {
            return "miscellaneous"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! VideosCell
        if indexPath.section == 0 {
            cell.videoLabel.text = trainingVideos[indexPath.row]
        } else if indexPath.section == 1 {
            cell.videoLabel.text = setupVideos[indexPath.row]
        } else {
            let (videoName, videoLocation) = miscVideos[indexPath.row]
            cell.videoLabel.text = videoName
            print(videoLocation)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let videoName = trainingVideos[indexPath.row]
            print(videoName)
        }
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
