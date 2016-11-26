//
//  ManagedObject+CoreDataClass.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedObject)
public class ManagedObject: NSManagedObject, FontManagedObjectType {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
