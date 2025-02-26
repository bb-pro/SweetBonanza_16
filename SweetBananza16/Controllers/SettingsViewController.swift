
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var soundStatusSlider: UISlider!
    @IBOutlet weak var musicStatusSlider: UISlider!
    
    var soundVolume = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.soundVolume) as? Float ?? 0.0
    
    var musicVolume = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.musicVolume) as? Float ?? 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInitialCases()
    }

    
    @IBAction func returnToBackTapped(_ sender: UIButton) {
        let sound = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.soundVolume) as? Float ?? 0.0
        let music = UserHavePowersManager.shared.takeValueBasedOnGivenKey(forkey: UserHavePowersManager.shared.musicVolume) as? Float ?? 0.0
        SoundControllerClass.shared.setSoundVolume(sound)
        SoundControllerClass.shared.setMusicVolume(music)
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonGotClicked(_ sender: UIButton) {
        UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.soundVolume, 
                                                         value: soundVolume)
        UserHavePowersManager.shared.resetNewValueForKey(forKey: UserHavePowersManager.shared.musicVolume,
                                                         value: musicVolume)
        dismiss(animated: true)
    }
    
    @IBAction func soundSlider(_ sender: UISlider) {
        soundVolume = sender.value
        SoundControllerClass.shared.setSoundVolume(soundVolume)
    }
    
    @IBAction func musicSlider(_ sender: UISlider) {
        musicVolume = sender.value
        SoundControllerClass.shared.setMusicVolume(musicVolume)
    }
}
extension SettingsViewController {
    private func configureInitialCases() {
        soundStatusSlider.setThumbImage(UIImage(named: "thumbImage"), for: .normal)
        musicStatusSlider.setThumbImage(UIImage(named: "thumbImage"), for: .normal)

        soundStatusSlider.value = soundVolume
        musicStatusSlider.value = musicVolume
    }
}
