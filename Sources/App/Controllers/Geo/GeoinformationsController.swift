import Vapor
import FluentPostgreSQL
import FluentQuery



struct GeoinformationsController: RouteCollection {
    
    func boot(router: Router) throws {
        let geoinformationsRoute = router.grouped("api","geoinformations")
        
        geoinformationsRoute.get(use: getAllHandler)
        geoinformationsRoute.get(Geoinformation.parameter, use: getHandler)

        //geoinformationsRoute.get(Geoinformation.parameter, "overview", use: getOverviewHandler)
        
        geoinformationsRoute.post(Geoinformation.self, use: createHandler)
        geoinformationsRoute.delete(Geoinformation.parameter, use: deleteHandler)
        
        geoinformationsRoute.get(Geoinformation.parameter, "locations", use: getLocationsHandler)
        geoinformationsRoute.post(Geoinformation.parameter, "locations", Geolocation.parameter, use: addLocationHandler)
        
        geoinformationsRoute.get(Geoinformation.parameter, "groups", use: getGroupsHandler)
        geoinformationsRoute.post(Geoinformation.parameter, "groups", Geogroup.parameter, use: addGroupHandler)
        
        
        //geoinformationsRoute.get(Geoinformation.parameter, "search", searchTerm: String, use: searchHandler)

        
        //geoinformationsRoute.post(Geoinformation.parameter, "parents", Geoinformation.parameter, use: addParentHandler)
    }
    
    
    func getAllHandler(_ req: Request) throws -> Future<[Geoinformation]> {
        return Geoinformation.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Geoinformation> {
        return try req.parameters.next(Geoinformation.self)
    }
    
    func createHandler(_ req: Request, geoinformation: Geoinformation) throws -> Future<Geoinformation> {
        return geoinformation.save(on: req)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Geoinformation.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func getLocationsHandler(_ req: Request) throws -> Future<[Geolocation]> {
        return try req.parameters.next(Geoinformation.self).flatMap(to: [Geolocation].self) { location in
            try location.geolocations.query(on: req).all()
        }
    }

    func addLocationHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Geoinformation.self), req.parameters.next(Geolocation.self)) { info, location in
            let pivot = try GeoinformationForGeolocation(info.requireID(), location.requireID())
            return pivot.save(on: req).transform(to: .created)
        }
    }
    
    func getGroupsHandler(_ req: Request) throws -> Future<[Geogroup]> {
        return try req.parameters.next(Geoinformation.self).flatMap(to: [Geogroup].self) { group in
            try group.geogroups.query(on: req).all()
        }
    }
    
    func addGroupHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Geoinformation.self),
                           req.parameters.next(Geogroup.self)) { info, group in
            let pivot = try GroupForGeoinformation(info.requireID(), group.requireID())
            return pivot.save(on: req).transform(to: .created)
        }
    }
    
    func searchHandler(_ req: Request) throws -> Future<[GeoSearchResult]> {
        let fq = FluentQuery()
            .select(\GeoSearchResult.id, as: "id")
            .select(\GeoSearchResult.title, as: "title")
            .from(GeoSearchResult.self)
            .where(FQWhere("\"_geosearchresult_\".document @@ to_tsquery('german', 'mensa')"))
        return req.requestPooledConnection(to: .psql).flatMap { conn -> EventLoopFuture<[GeoSearchResult]> in
            defer { try? req.releasePooledConnection(conn, to: .psql) }
            print(fq)
            return try fq
                .execute(on: conn)
                .decode(GeoSearchResult.self)
        }
    }
    
}
