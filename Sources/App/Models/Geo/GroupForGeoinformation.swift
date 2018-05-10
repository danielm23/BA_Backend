import FluentPostgreSQL
import Vapor
import Foundation

final class GroupForGeoinformation: PostgreSQLPivot {
    var id: Int?
    
    //var id: UUID
    var geoinformationId: Geoinformation.ID
    var geogroupId: Geogroup.ID
    
    typealias Left = Geoinformation
    typealias Right = Geogroup
    
    static var leftIDKey: WritableKeyPath<GroupForGeoinformation, Geoinformation.ID> {
        return \GroupForGeoinformation.geoinformationId
    }
    
    static var rightIDKey: WritableKeyPath<GroupForGeoinformation, Geogroup.ID> {
        return \GroupForGeoinformation.geogroupId
    }
    
    init(_ geoinformationId: Geoinformation.ID, _ geolocationId: Geogroup.ID) {
        self.geoinformationId = geoinformationId
        self.geogroupId = geolocationId
    }
}

extension GroupForGeoinformation: Migration { }
