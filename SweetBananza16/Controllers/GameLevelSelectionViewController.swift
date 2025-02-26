
import UIKit

class GameLevelSelectionViewController: UIViewController {
    @IBOutlet weak var leftStageImageView: UIImageView!
    @IBOutlet var levelButtonOutletCollection: [UIButton]!
    
    var stage: Int?
    let keys = [UserHavePowersManager.shared.gameStage1Level, UserHavePowersManager.shared.gameStage2Level, UserHavePowersManager.shared.gameStage3Level]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stage = stage {
            var value = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.playedThreeLocation) as! [Int]
            if !value.contains(stage + 1) {
                value.append(stage + 1)
                UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.playedThreeLocation, value: value)
            }
            if value.contains(1) || value.contains(2) || value.contains(3) {
                var trophies = UserHavePowersManager.shared.getTrophies()
                if !trophies.contains(3) {
                    trophies.append(3)
                    UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.openedTrophies, value: trophies)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserAppearanceBasedOnStageValue()
    }
    
    @IBAction func returnGotClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func levelSelected(_ sender: UIButton) {
        guard let stage = stage else { return }
        if sender.tag == 0 && stage == 0 {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "GuidanceViewController") as? GuidanceViewController {
                navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "CrucialGameViewController") as? CrucialGameViewController {
                viewController.stage = stage
                viewController.level = sender.tag
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
private extension GameLevelSelectionViewController {
    private func setupUserAppearanceBasedOnStageValue() {
        guard let stage = stage else { return }
        leftStageImageView.image = UIImage(named: "gameStage\(stage)")
        guard let levelValue = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: keys[stage]) as? Int else { return }
        
        for btn in levelButtonOutletCollection {
            btn.setTitle("\(btn.tag + 1)", for: .normal)
            if btn.tag < levelValue {
                btn.setBackgroundImage(UIImage(named: "playedButtonBack"), for: .normal)
                btn.isUserInteractionEnabled = true
            } else if btn.tag == levelValue {
                btn.setBackgroundImage(UIImage(named: "currentLevelButtonBack"), for: .normal)
                btn.isUserInteractionEnabled = true
            } else {
                btn.setBackgroundImage(UIImage(named: "lockedLevelsButtonBack"), for: .normal)
                btn.isUserInteractionEnabled = false
            }
        }
    }
}
