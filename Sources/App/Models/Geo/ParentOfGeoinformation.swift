import FluentPostgreSQL
import Vapor
import Foundation

final class ParentOfGeoinformation: PostgreSQLPivot {
    var id: Int?
    
    //var id: UUID
    var geoinformationId: Geoinformation.ID
    var parentId: Geoinformation.ID
    
    typealias Left = Geoinformation
    typealias Right = Geoinformation
    
    static var leftIDKey: WritableKeyPath<ParentOfGeoinformation, Geoinformation.ID> {
        return \ParentOfGeoinformation.geoinformationId
    }
    
    static var rightIDKey: WritableKeyPath<ParentOfGeoinformation, Geoinformation.ID> {
        return \ParentOfGeoinformation.parentId
    }
    
    init(_ geoinformationId: Geoinformation.ID, _ parentId: Geoinformation.ID) {
        self.geoinformationId = geoinformationId
        self.parentId = parentId
    }
}

extension ParentOfGeoinformation: Migration { }
