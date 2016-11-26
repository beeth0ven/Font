//
//  CoreDataStack+Font.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import CoreData
import BNKit

protocol FontManagedObjectType: ManagedObjectType {}

extension FontManagedObjectType {
    
    public static var coreDataStack: CoreDataStack {
        return .Font
    }
}

extension CoreDataStack {
    static let Font = CoreDataStack(modelName: "Font")
}
