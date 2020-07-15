//
//  Show.swift
//  salinas-test
//
//  Created by Macintosh HD on 14/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import RealmSwift

class Show: Object, Codable {

    @objc dynamic var status: String = ""
    @objc dynamic var rating: ShowRating?
    @objc dynamic var weight: Int = 0
    @objc dynamic var updated: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var language: String = ""
    @objc dynamic var schedule: ShowSchedule?
    @objc dynamic var url: String = ""
    @objc dynamic var officialSite: String? = nil
    @objc dynamic var externals: ShowExternals?
    @objc dynamic var premiered: String = ""
    @objc dynamic var summary: String = ""
    @objc dynamic var _links: ShowLinks?
    @objc dynamic var image: ShowImage?
    @objc dynamic var webChannel: ShowWebChannel?
    @objc dynamic var runtime: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var network: ShowNetwork?
    @objc dynamic var isFavorite = false
    
    private enum CodingKeys: String, CodingKey {
        case status
        case rating
        case weight
        case updated
        case name
        case language
        case schedule
        case url
        case officialSite
        case externals
        case premiered
        case summary
        case _links
        case image
        case webChannel
        case runtime
        case type
        case id
        case network
    }

    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func all(in realm: Realm = try! Realm()) -> Results<Show> {
        return realm.objects(Show.self)
    }
    
    static func add(_ shows: [Show], in realm: Realm = try! Realm()) {
        
        do {
            try realm.write {
                realm.add(shows)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }

}

class ShowRating: Object, Codable {

    var average = RealmOptional<Float>()

}

class ShowSchedule: Object, Codable {

    var days = List<String>()
    @objc dynamic var time: String = ""

}

class ShowExternals: Object, Codable {

    var thetvdb = RealmOptional<Int>()
    @objc dynamic var tvrage: Int = 0
    @objc dynamic var imdb: String? = nil

}

class ShowLinks: Object, Codable {

    @objc dynamic var previousepisode: ShowPreviousepisode?

}

class ShowImage: Object, Codable {

    @objc dynamic var medium: String = ""
    @objc dynamic var original: String = ""

}

class ShowNetwork: Object, Codable {

    @objc dynamic var country: ShowCountry?
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""

}

class ShowPreviousepisode: Object, Codable {

    @objc dynamic var href: String = ""

}

class ShowSelf: Object, Codable {

    @objc dynamic var href: String = ""

}

class ShowCountry: Object, Codable {

    @objc dynamic var timezone: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var name: String = ""

}

class ShowWebChannel: Object, Codable {

    @objc dynamic var country: ShowCountry?
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""

}
