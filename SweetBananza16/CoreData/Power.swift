
import UIKit
import CoreData

@objc(Power)
public class Power: NSManagedObject {
}

extension Power {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Power> {
        return NSFetchRequest<Power>(entityName: "Power")
    }
    
    @NSManaged public var coin: Int16
    @NSManaged public var misteryBox: Int16
    @NSManaged public var timeFreezer: Int16
}

