import FluentPostgreSQL
import Vapor
import Foundation

final class ParentOfGeogroup: PostgreSQLPivot {
    var id: Int?
    
    //var id: UUID
    var geogroupId: Geogroup.ID
    var parentId: Geogroup.ID
    
    typealias Left = Geogroup
    typealias Right = Geogroup
    
    static var leftIDKey: WritableKeyPath<ParentOfGeogroup, Geogroup.ID> {
        return \ParentOfGeogroup.geogroupId
    }
    
    static var rightIDKey: WritableKeyPath<ParentOfGeogroup, Geogroup.ID> {
        return \ParentOfGeogroup.parentId
    }
    
    init(_ geogroupId: Geogroup.ID, _ parentId: Geogroup.ID) {
        self.geogroupId = geogroupId
        self.parentId = parentId
    }
}

extension ParentOfGeogroup: Migration { }
