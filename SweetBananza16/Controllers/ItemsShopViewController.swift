
import UIKit

class ItemsShopViewController: UIViewController {
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet var powerAmountLabels: [UILabel]!
    @IBOutlet var powerShopViews: [UIView]!
    @IBOutlet weak var shopTitleLabel: UILabel!
    @IBOutlet var skinImages: [UIImageView]!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    var isPower: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moneyLabel.text = "\(UserHavePowersManager.shared.fetchCoin())"
    }
    
    @IBAction func goToBackTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func questionMarkTapped(_ sender: UIButton) {
        if let pushAlert = storyboard?.instantiateViewController(withIdentifier: "CustomBlurredAlertViewController") as? CustomBlurredAlertViewController {
            pushAlert.contextName = (sender.tag == 0) ? "Mystery Box" : "Time Freezer"
            pushAlert.imageName = (sender.tag == 0) ? "misteryBoxImage" : "timeFreezeImage"
            pushAlert.info = (sender.tag == 0) ? "This booster will allow you to get a random artifact in the game" : "This booster stops time in the game for 10 seconds"
            pushAlert.buttonTitle = "Okay!"
            present(pushAlert, animated: true)
        }
    }
    
    @IBAction func buyGotClicked(_ sender: UIButton) {
        if UserHavePowersManager.shared.fetchCoin() >= 50 {
            if sender.tag == 0 {
                UserHavePowersManager.shared.updateComponents(coin: (UserHavePowersManager.shared.fetchCoin() - 50), misteryBox: (UserHavePowersManager.shared.fetchMisteryBox() + 1), timeFreezer: nil)
            } else {
                UserHavePowersManager.shared.updateComponents(coin: (UserHavePowersManager.shared.fetchCoin() - 50), misteryBox: nil, timeFreezer: (UserHavePowersManager.shared.fetchTimeFreezer() + 1))
            }
            setupUI()
            moneyLabel.text = "\(UserHavePowersManager.shared.fetchCoin())"
        }
    }
    
    private func setupUI() {
        guard let isPower = isPower else { return }
        if isPower {
            let cellWidth = (UIScreen.main.bounds.height - 108) * (177/246)
            leftConstraint.constant = (UIScreen.main.bounds.width / 2) - cellWidth - 15
            leftConstraint.isActive = true
            for lbl in powerAmountLabels {
                if lbl.tag == 0 {
                    lbl.text = "\(UserHavePowersManager.shared.fetchMisteryBox())"
                } else {
                    lbl.text = "\(UserHavePowersManager.shared.fetchTimeFreezer())"
                }
            }
            for img in skinImages {
                img.isHidden = true
            }
        } else {
            for powerView in powerShopViews {
                powerView.isHidden = true
            }
        }
    }
}
