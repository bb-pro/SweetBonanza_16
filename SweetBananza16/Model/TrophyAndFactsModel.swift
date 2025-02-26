
import Foundation

struct TrophyAndFactsModel {
    let trophy: String
    let fact: String
    
    static func fetchData() -> [TrophyAndFactsModel] {
        [
            TrophyAndFactsModel(trophy: "To get this achievement, Complete the first level.", fact: "Chocolate protects our skin from the sun. The flavonoids in it absorb UV radiation, thus helping to protect our skin."),
            TrophyAndFactsModel(trophy: "To get this achievement, Research your first fact about sweets", fact: "It is found that in ancient India, Dalit peoples boiled sugarcane on fire, so they are considered the discoverers of caramel"),
            TrophyAndFactsModel(trophy: "To get this achievement, Play in at least three locations", fact: "Pastry chefs joke that if you learn to make real air eclairs the first time, the first academic step in cooking is passed."),
            TrophyAndFactsModel(trophy: "To get this achievement, Use the mystic box booster 5 times", fact: "Leden was first invented in China over 2,000 years ago and was made from berries and fruits mixed with honey, which were then frozen in ice."),
            TrophyAndFactsModel(trophy: "To get this achievement, Use the time freeze booster 10 times", fact: "The first cookies are believed to date back to the 7th century AD in Persia, when sugar became widely available in that region."),
            TrophyAndFactsModel(trophy: "To get this achievement, Complete at least 14 levels.", fact: " Jello contains many amino acids and is sometimes considered beneficial for healthy skin, hair and nails. But some people may be allergic to gelatin."),
            TrophyAndFactsModel(trophy: "To get this achievement, Play in at least five locations", fact: "In some countries, such as the UK, licorice is preferred sweet, in the Nordic countries and Holland it is usually eaten salted."),
            TrophyAndFactsModel(trophy: "To get this achievement, Research at least 10 facts about sweets.", fact: "It was originally a medicine. Indeed, these deliciously soft candies were originally used as cough lozenges.")
        ]
    }
}
