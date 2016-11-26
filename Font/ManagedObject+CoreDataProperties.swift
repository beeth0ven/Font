//
//  ManagedObject+CoreDataProperties.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData


extension ManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedObject> {
        return NSFetchRequest<ManagedObject>(entityName: "ManagedObject");
    }

    @NSManaged public var creationDate: Date
    @NSManaged public var caption: String?

}
