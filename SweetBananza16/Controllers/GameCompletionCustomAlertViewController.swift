
import UIKit

class GameCompletionCustomAlertViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var coinAmountLabel: UILabel!
    @IBOutlet weak var coinGroupView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var isWon: Bool?
    var level: Int?
    var stage: Int?
    var allPrizes: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        declareInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isWon {
            SoundControllerClass.shared.stopBackgroundMusic()
            SoundControllerClass.shared.stopGameBackMusic()
            if isWon {
                SoundControllerClass.shared.playWinSound()
            } else {
                SoundControllerClass.shared.playLoseSound()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SoundControllerClass.shared.stopWinSound()
        SoundControllerClass.shared.stopLoseSound()
        SoundControllerClass.shared.playBackgroundMusic()
    }
    
    @IBAction func topButtonTapped(_ sender: UIButton) {
        if let isWon = isWon {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "CrucialGameViewController") as! CrucialGameViewController
            viewController.stage = stage
            if isWon {
                guard let level = level else { return }
                if level < 7 {
                    viewController.level = level + 1
                } else {
                    viewController.level = level
                }
            } else {
                    viewController.level = level
            }
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        if let isWon = isWon {
            if isWon {
                navigationController?.popViewController(animated: true)
            } else {
                if let viewC = storyboard?.instantiateViewController(withIdentifier: "ShopRootViewController") as? ShopRootViewController {
                    navigationController?.pushViewController(viewC, animated: true)
                }
            }
        } else {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "CrucialGameViewController") as? CrucialGameViewController {
                viewController.level = level
                viewController.stage = stage
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
private extension GameCompletionCustomAlertViewController {
    private func declareInitialSetup() {
        rightButton.setBackgroundImage(UIImage(named: "menuButton"), for: .normal)
        if let isWon = isWon {
            if isWon {
                UserHavePowersManager.shared.updateComponents(coin: UserHavePowersManager.shared.fetchCoin() + (allPrizes ?? 0), misteryBox: nil, timeFreezer: nil)
                if let level = level, let stage = stage {
                    if level < 7 {
                        var trophies = UserHavePowersManager.shared.getTrophies()
                        if level == 0 {
                            if !trophies.contains(1) {
                                trophies.append(1)
                                UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.openedTrophies, value: trophies)
                            }
                        }
                        
                        let firstLevelValue = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.gameStage1Level) as! Int
                        let secondLevelValue = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.gameStage2Level) as! Int
                        let thirdLevelValue = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.gameStage3Level) as! Int
                        if firstLevelValue + secondLevelValue + thirdLevelValue >= 14 {
                            if !trophies.contains(6) {
                                trophies.append(6)
                                UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.openedTrophies, value: trophies)
                            }
                        }
                        UserHavePowersManager.shared.resetNewValueForKey(forKey: "gameStage\(stage + 1)Level", value: level + 1)
                    }
                }
                backgroundImageView.image = UIImage(named: "winBack")
                leftImageView.image = UIImage(named: "mainScreenLadyImage")
                coinGroupView.isHidden = false
                titleLabel.text = "You Win!"
                subtitleLabel.text = "You've masterfully passed the level"
                topButton.setBackgroundImage(UIImage(named: "nextButton"), for: .normal)
                leftButton.setBackgroundImage(UIImage(named: "restartButton"), for: .normal)
            } else {
                leftImageView.image = UIImage(named: "gameOverLeftImage")
                coinGroupView.isHidden = true
                titleLabel.text = "Game Over!"
                subtitleLabel.text = "Unfortunately, the level failed"
                topButton.setBackgroundImage(UIImage(named: "restartBigButton"), for: .normal)
                leftButton.setBackgroundImage(UIImage(named: "shopButtonBackImage"), for: .normal)
            }
        } else {
            leftImageView.image = UIImage(named: "pauseLeftImage")
            coinGroupView.isHidden = true
            titleLabel.text = "Pause"
            subtitleLabel.text = "Game paused"
            topButton.setBackgroundImage(UIImage(named: "resumeBigButton"), for: .normal)
            leftButton.setBackgroundImage(UIImage(named: "restartButton"), for: .normal)
        }
    }
}
