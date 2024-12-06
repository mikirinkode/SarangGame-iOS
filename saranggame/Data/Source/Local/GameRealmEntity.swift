//
//  GameLocalObject.swift
//  saranggame
//
//  Created by Wafa on 06/12/24.
//

import Foundation
import RealmSwift

class GameRealmEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String = ""
    @Persisted var released: Date = Date()
    @Persisted var backgroundImage: String = "" // Save as String (URL can be reconstructed)
    @Persisted var rating: Double = 0.0
}
