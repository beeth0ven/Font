//
//  Application+CoreDataProperties.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData


extension Application {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Application> {
        return NSFetchRequest<Application>(entityName: "Application");
    }

    @NSManaged public var name: String?
    @NSManaged public var colors: Set<Color>
    @NSManaged public var fonts: Set<Font>

}

// MARK: Generated accessors for colors
extension Application {

    @objc(addColorsObject:)
    @NSManaged public func addToColors(_ value: Color)

    @objc(removeColorsObject:)
    @NSManaged public func removeFromColors(_ value: Color)

    @objc(addColors:)
    @NSManaged public func addToColors(_ values: NSSet)

    @objc(removeColors:)
    @NSManaged public func removeFromColors(_ values: NSSet)

}

// MARK: Generated accessors for fonts
extension Application {

    @objc(addFontsObject:)
    @NSManaged public func addToFonts(_ value: Font)

    @objc(removeFontsObject:)
    @NSManaged public func removeFromFonts(_ value: Font)

    @objc(addFonts:)
    @NSManaged public func addToFonts(_ values: NSSet)

    @objc(removeFonts:)
    @NSManaged public func removeFromFonts(_ values: NSSet)

}
