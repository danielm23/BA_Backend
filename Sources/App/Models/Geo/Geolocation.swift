import FluentPostgreSQL
import Vapor

final class Geolocation: PostgreSQLModel {
    var id: Int?
    var adress: String?
    var zip: String?
    var city: String?
    var country: String?
    var longitude: Double?
    var latitude: Double?
    //var location: PostgreSQLPoint?
    var floor: Int?
    var created: Date?
    var updated: Date?
    var userId: Int?
    
    static var createdAtKey: TimestampKey? = \.created
    static var updatedAtKey: TimestampKey? = \.updated

    init(
         adress: String,
         zip: String,
         city: String,
         country: String,
         longitude: Double,
         latitude: Double,
         floor: Int
         ) {
        self.adress = adress
        self.zip = zip
        self.city = city
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
        self.floor = floor
        //self.location = PostgreSQLPoint(x: x, y: y)
    }
}

extension Geolocation: Migration { }

extension Geolocation: Content { }

extension Geolocation: Parameter { }

extension Geolocation {
    var events: Children<Geolocation, Geoinformation>{
        return children(\.geolocationId)
    }
    /*
    var geoinformations: Siblings<Geolocation, Geoinformation, GeoinformationForGeolocation> {
        return siblings()
    }
    
    var children
    
    var parents*/
}
