
import UIKit

class TrophiesAndFactsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var questionMarkButtons: [UIButton]!
    @IBOutlet var trophyOrFactNameLabels: [UILabel]!
    @IBOutlet var centerImages: [UIImageView]!
    @IBOutlet var tickImageViews: [UIImageView]!
    @IBOutlet var backViews: [UIView]!
    
    var isTrophy: Bool?
    let trophyNames = ["""
The
Seeker
""", """
The
Cognizer
""", """
The
Traveler
""", """
The
Lucky
""", """
Master
Freezer
""", """
Experienced
Seeker
""", """
Experienced
Traveler
""", """
Experienced
Cognizer
"""
    ]
    let factNames = ["""
Chocolate
Fact
""", """
Caramel
Fact
""", """
Eclair
Fact
""", """
Lolipop
Fact
""", """
Cookies
Fact
""", """
Jello
Fact
""", """
Licorice
Fact
""", """
Marshmallow
Fact
"""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let openFacts = UserHavePowersManager.shared.getFacts()
        if openFacts.count >= 10 {
            var trophies = UserHavePowersManager.shared.getTrophies()
            if !trophies.contains(8) {
                trophies.append(8)
                UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.openedTrophies, value: trophies)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUIBasedOnViewStatus()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func questionButtonTapped(_ sender: UIButton) {
        print("clicked \(sender.tag)")
        guard let isTrophy = isTrophy else { return }
        if let pushToInfo = storyboard?.instantiateViewController(withIdentifier: "CustomBlurredAlertViewController") as? CustomBlurredAlertViewController {
            pushToInfo.contextName = isTrophy ? trophyNames[sender.tag] : factNames[sender.tag]
            pushToInfo.imageName = isTrophy ? "trophy\(sender.tag)" : "fact\(sender.tag)"
            pushToInfo.info = isTrophy ? TrophyAndFactsModel.fetchData()[sender.tag].trophy : TrophyAndFactsModel.fetchData()[sender.tag].fact
            pushToInfo.buttonTitle = isTrophy ? "Okay!" : "Interesting!"
            pushToInfo.modalPresentationStyle = .overFullScreen
            var trophies = UserHavePowersManager.shared.getTrophies()
            if !trophies.contains(2) {
                trophies.append(2)
                UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.openedTrophies, value: trophies)
            }
            present(pushToInfo, animated: true)
        }
    }
}
extension TrophiesAndFactsViewController {
    private func setupUIBasedOnViewStatus() {
        let level1 = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.gameStage1Level) as! Int
        let level2 = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.gameStage2Level) as! Int
        let level3 = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.gameStage3Level) as! Int
        let openedFacts = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.openedFacts) as! [Int]
        let openedTrophies = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.openedTrophies) as! [Int]
        let levelsValuesArray = [level1, level2, level3]
        guard let isTrophy = isTrophy else { return }
        
        if isTrophy {
            titleLabel.text = "Trophies \(openedTrophies.count)＼8"
        } else {
            titleLabel.text = "Facts \(openedFacts.count)＼8"
        }
        
        for img in centerImages {
            img.image = isTrophy ? UIImage(named: "trophy\(img.tag)") : UIImage(named: "fact\(img.tag)")
        }
        for trophyLabel in trophyOrFactNameLabels {
            if isTrophy {
                trophyLabel.text = trophyNames[trophyLabel.tag]
            } else {
                if trophyLabel.tag <= levelsValuesArray.min() ?? 0 {
                    trophyLabel.text = factNames[trophyLabel.tag]
                } else {
                    trophyLabel.text = "Locked"
                }
            }
        }
        if isTrophy {
            for tickImage in tickImageViews {
                if openedTrophies.contains(tickImage.tag + 1) {
                    tickImage.image = UIImage(named: "tickImage")
                } else {
                    tickImage.image = nil
                }
            }
        } else {
            for tickImage in tickImageViews {
                if openedFacts.contains(tickImage.tag + 1) {
                    tickImage.image = UIImage(named: "tickImage")
                } else {
                    tickImage.image = nil
                }
            }
            for centerImage in centerImages {
                centerImage.isHidden = !(centerImage.tag <= levelsValuesArray.min() ?? 0)
            }
            for vw in backViews {
                if vw.tag <= levelsValuesArray.min() ?? 0 {
                    vw.alpha = 1.0
                    vw.isUserInteractionEnabled = true
                } else {
                    vw.alpha = 0.5
                    vw.isUserInteractionEnabled = false
                }
            }
        }
    }
}
