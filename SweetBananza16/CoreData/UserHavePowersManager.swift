
import UIKit
import CoreData

class UserHavePowersManager {
    static let shared = UserHavePowersManager()
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var gameStage1Level = "gameStage1Level"
    var gameStage2Level = "gameStage2Level"
    var gameStage3Level = "gameStage3Level"
    var openedTrophies = "openedTrophies"
    var openedFacts = "openedFacts"
    let playedThreeLocation = "playedThreeLocation"
    let usedMisteryBox = "usedMisteryBox"
    let freezerAmount = "freezerAmount"
    let soundVolume = "soundVolume"
    let musicVolume = "musicVolume"
    let initialLoad = "initialLoad"
    var userDefaults = UserDefaults.standard
    
    private init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    func giveInitialValues() {
        if userDefaults.value(forKey: gameStage1Level) == nil {
            userDefaults.setValue(0, forKey: gameStage1Level)
        }
        
        if userDefaults.value(forKey: gameStage2Level) == nil {
            userDefaults.setValue(0, forKey: gameStage2Level)
        }
        
        if userDefaults.value(forKey: gameStage3Level) == nil {
            userDefaults.setValue(0, forKey: gameStage3Level)
        }
        
        if userDefaults.value(forKey: soundVolume) == nil {
            userDefaults.setValue(0.5, forKey: soundVolume)
        }
        
        if userDefaults.value(forKey: musicVolume) == nil {
            userDefaults.setValue(0.5, forKey: musicVolume)
        }
        
        if userDefaults.value(forKey: openedFacts) == nil {
            userDefaults.setValue([0], forKey: openedFacts)
        }
        
        if userDefaults.value(forKey: openedTrophies) == nil {
            userDefaults.setValue([0], forKey: openedTrophies)
        }
        
        if userDefaults.value(forKey: playedThreeLocation) == nil {
            userDefaults.setValue([0], forKey: playedThreeLocation)
        }
        
        if userDefaults.value(forKey: usedMisteryBox) == nil {
            userDefaults.setValue(0, forKey: usedMisteryBox)
        }
        
        if userDefaults.value(forKey: freezerAmount) == nil {
            userDefaults.setValue(0, forKey: freezerAmount)
        }
        
        if userDefaults.value(forKey: initialLoad) == nil {
            userDefaults.setValue(true, forKey: initialLoad)
        }
    }
    
    func resetNewValueForKey(forKey key: String, value: Any) {
        userDefaults.setValue(value, forKey: key)
    }
    
    func getFacts() -> [Int] {
        return userDefaults.value(forKey: "openedFacts") as! [Int]
    }
    
    func getTrophies() -> [Int] {
        return userDefaults.value(forKey: "openedTrophies") as! [Int]
    }
    
    func takeValueBasedOnGivenKey(forkey key: String) -> Any {
        return userDefaults.value(forKey: key) as Any
    }
    
    func updateComponents(coin: Int?, misteryBox: Int?, timeFreezer: Int?) {
        let power = fetchPower()

        if let coin = coin {
            power.coin = Int16(coin)
        }
        
        if let misteryBox = misteryBox {
            power.misteryBox = Int16(misteryBox)
        }
        
        if let timeFreezer = timeFreezer {
            power.timeFreezer = Int16(timeFreezer)
        }
        
        remaintainContext()
    }
    
    private func fetchPower() -> Power {
        let fetchRequest: NSFetchRequest<Power> = Power.fetchRequest()

        do {
            let powers = try context.fetch(fetchRequest)
            if let power = powers.first {
                return power
            } else {
                let newPower = Power(context: context)
                newPower.coin = 100
                newPower.misteryBox = 0
                newPower.timeFreezer = 0
                remaintainContext()
                return newPower
            }
        } catch {
            print("Failed to fetch Power entity: \(error.localizedDescription)")
            let newPower = Power(context: context)
            newPower.coin = 100
            newPower.misteryBox = 0
            newPower.timeFreezer = 0
            remaintainContext()
            return newPower
        }
    }
    
    func fetchCoin() -> Int {
        return Int(fetchPower().coin )
    }
    
    func fetchMisteryBox() -> Int {
        return Int(fetchPower().misteryBox)
    }
    
    func fetchTimeFreezer() -> Int {
        return Int(fetchPower().timeFreezer)
    }
    
    private func remaintainContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
