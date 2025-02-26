
import UIKit
import SpriteKit

class CrucialGameViewController: UIViewController {
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var misteryBoxAmountLabel: UILabel!
    @IBOutlet weak var timeFreezeAmountLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    @IBOutlet weak var availableCoinLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var level: Int?
    var stage: Int?
    var candiesAmount: Int = 0
    var chocolateAmount: Int = 0
    var countdownTimer: Timer?
    var remainingTime: Int = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SoundControllerClass.shared.stopBackgroundMusic()
        SoundControllerClass.shared.playGameBackMusic()
        SoundControllerClass.shared.stopWinSound()
        SoundControllerClass.shared.stopLoseSound()
        showPowers()
        resumeTimer()
    }
    
    private func setupGameScene() {
        if let scene = CrucialGameScene(fileNamed: "JumpGameScene") {
            print("Initialized successfully")
            scene.scaleMode = .aspectFill
            scene.gameViewController = self
            scene.level = level
            scene.stage = stage
            skView.presentScene(scene)

            skView.ignoresSiblingOrder = false
            skView.showsFPS = false
            skView.showsNodeCount = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        pushToWin(to: nil)
    }
    
    @IBAction func misteryBoxTapped(_ sender: UIButton) {
        let misteryBox = UserHavePowersManager.shared.fetchMisteryBox()
        if misteryBox > 0 {
            var misteryBoxUsed = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.usedMisteryBox) as! Int
            misteryBoxUsed += 1
            UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.usedMisteryBox, value: misteryBoxUsed )
            if misteryBoxUsed == 5 {
                var trophies = UserHavePowersManager.shared.getTrophies()
                if !trophies.contains(4) {
                    trophies.append(4)
                    UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.openedTrophies, value: trophies)
                }
            }
            let randomValue = Bool.random()
            if randomValue {
                candiesAmount += 1
            } else {
                chocolateAmount += 1
            }
            UserHavePowersManager.shared.updateComponents(coin: nil, misteryBox: misteryBox - 1, timeFreezer: nil)
        }
        showPowers()
    }
    
    @IBAction func timeFreezeGotClicked(_ sender: UIButton) {
        let leftTimeFreeze = UserHavePowersManager.shared.fetchTimeFreezer()
        if leftTimeFreeze > 0 {
            var freezerAmount = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.freezerAmount) as! Int
            freezerAmount += 1
            UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.freezerAmount, value: freezerAmount)
            if freezerAmount == 10 {
                var trophies = UserHavePowersManager.shared.getTrophies()
                if !trophies.contains(5) {
                    trophies.append(5)
                    UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.openedTrophies, value: trophies)
                }
            }
            remainingTime += 10
            UserHavePowersManager.shared.updateComponents(coin: nil, misteryBox: nil, timeFreezer: leftTimeFreeze - 1)
        }
        showPowers()
    }
}
extension CrucialGameViewController {
    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            
            countdownTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            countdownTimer?.invalidate()
            countdownTimerLabel.text = "00:00"
            pushToWin(to: true)
        }
    }
    
    func pauseTimer() {
        countdownTimer?.invalidate()
    }

    func resumeTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func pushToWin(to isWin: Bool?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameCompletionCustomAlertViewController") as? GameCompletionCustomAlertViewController {
            vc.isWon = isWin
            vc.level = level
            vc.stage = stage
            vc.allPrizes = candiesAmount + chocolateAmount
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showPowers() {
        misteryBoxAmountLabel.text = "\(UserHavePowersManager.shared.fetchMisteryBox())"
        timeFreezeAmountLabel.text = "\(UserHavePowersManager.shared.fetchTimeFreezer())"
        availableCoinLabel.text = "\( UserHavePowersManager.shared.fetchCoin())"
    }
}
