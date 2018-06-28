import FluentPostgreSQL
import Vapor
import Foundation
/*
final class GeoinformationForGeolocation: PostgreSQLPivot {
    var id: Int?

    var geoinformationId: Geoinformation.ID
    var geolocationId: Geolocation.ID
    
    typealias Left = Geoinformation
    typealias Right = Geolocation
    
    static var leftIDKey: WritableKeyPath<GeoinformationForGeolocation, Geoinformation.ID> {
        return \GeoinformationForGeolocation.geoinformationId
    }
    
    static var rightIDKey: WritableKeyPath<GeoinformationForGeolocation, Geolocation.ID> {
        return \GeoinformationForGeolocation.geolocationId
    }
    
    init(_ geoinformationId: Geoinformation.ID, _ geolocationId: Geolocation.ID) {
        self.geoinformationId = geoinformationId
        self.geolocationId = geolocationId
    }
}

extension GeoinformationForGeolocation: Migration { }
*/
