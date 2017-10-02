import UIKit

class Step1VideoVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: "https://player.vimeo.com/video/169805431")!))
        webView.mediaPlaybackRequiresUserAction = false     // begin playing automatically
        webView.mediaPlaybackAllowsAirPlay = true
        webView.allowsInlineMediaPlayback = false // only go full screen, not in place
        // OLD
//        webView.loadHTMLString("<iframe width=\"\(webView.frame.width)\" height=\"\(webView.frame.height)\" src=\"https://www.youtube.com/embed/d-bw5eV8BdY\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
