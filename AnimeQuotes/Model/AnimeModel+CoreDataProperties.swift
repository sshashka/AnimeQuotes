//
//  AnimeModel+CoreDataProperties.swift
//  AnimeQuotes
//
//  Created by Саша Василенко on 13.09.2022.
//
//

import Foundation
import CoreData


extension AnimeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnimeModel> {
        return NSFetchRequest<AnimeModel>(entityName: "AnimeModel")
    }

    @NSManaged public var anime: String?
    @NSManaged public var character: String?
    @NSManaged public var identifier: UUID?
    @NSManaged public var quote: String?

}

extension AnimeModel : Identifiable {

}
