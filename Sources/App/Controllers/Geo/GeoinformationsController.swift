import Vapor
import FluentPostgreSQL


struct GeoinformationsController: RouteCollection {
    
    func boot(router: Router) throws {
        let geoinformationsRoute = router.grouped("api","geoinformations")
        
        geoinformationsRoute.get(use: getAllHandler)
        geoinformationsRoute.get("overview", use: getOverviewHandler)
        
        geoinformationsRoute.post(Geoinformation.self, use: createHandler)
        geoinformationsRoute.delete(Geoinformation.parameter, use: deleteHandler)
        
        geoinformationsRoute.get(Geoinformation.parameter, "locations", use: getLocationsHandler)
        geoinformationsRoute.post(Geoinformation.parameter, "locations", Geolocation.parameter, use: addLocationHandler)
        
        geoinformationsRoute.get(Geoinformation.parameter, "groups", use: getGroupsHandler)
        geoinformationsRoute.post(Geoinformation.parameter, "groups", Geogroup.parameter, use: addGroupHandler)
        
        geoinformationsRoute.post(Geoinformation.parameter, "parents", Geoinformation.parameter, use: addParentHandler)
    }
    
    
    func getAllHandler(_ req: Request) throws -> Future<[Geoinformation]> {
        return Geoinformation.query(on: req).all()
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
    /*
    func getParentsHandler(_ req: Request) throws -> Future<[Geoinformation]> {
        return try req.parameters.next(Geoinformation.self).flatMap(to: [Geoinformation].self) { group in
            try group.geogroups.query(on: req).all()
        }
    }*/
    
    func addParentHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Geoinformation.self),
                           req.parameters.next(Geogroup.self)) { info, parent in
                            let pivot = try ParentOfGeoinformation(info.requireID(), parent.requireID())
                            return pivot.save(on: req).transform(to: .created)
        }
    }
    func getOverviewHandler(_ req: Request) throws -> Future<[GeoOverview]> {
        return try GeoOverview.query(on: req).filter(\GeoOverview.group == "Gebäude").all()
    }
    /*
    func getChildrenHandler(_ req: Request) throws -> Future<[GeoOverview]> {
        return try GeoOverview.query(on: req).filter(\GeoOverview.parentId == req.parameters.next(GeoOverview.self).map(to: String)).all()
    }
     */
}
