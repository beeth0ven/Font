//
//  Font+CoreDataProperties.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData


extension Font {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Font> {
        return NSFetchRequest<Font>(entityName: "Font");
    }

    @NSManaged public var fontRawValue: String?
    @NSManaged public var application: Application?

}
