import Vapor

struct GeogroupsController: RouteCollection {
    
    func boot(router: Router) throws {
        let geogroupRoute = router.grouped("api","geogroups")
        geogroupRoute.get(use: getAllHandler)
        geogroupRoute.post(Geogroup.self, use: createHandler)
        geogroupRoute.get(Geogroup.parameter, use: getHandler)
        geogroupRoute.delete(Geogroup.parameter, use: deleteHandler)
        geogroupRoute.get(Geolocation.parameter, "infos", use: getInformationsHandler)
        geogroupRoute.get(Geolocation.parameter, "children", use: getChildrenHandler)
        geogroupRoute.get(Geolocation.parameter, "parents", use: getParentsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Geogroup]> {
        return Geogroup.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Geogroup> {
        return try req.parameters.next(Geogroup.self)
    }
    
    func createHandler(_ req: Request, geogroup: Geogroup) throws -> Future<Geogroup> {
        return geogroup.save(on: req)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Geogroup.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func getInformationsHandler(_ req: Request) throws -> Future<[Geoinformation]> {
        return try req.parameters.next(Geogroup.self).flatMap(to: [Geoinformation].self) { info in
            try info.geoinformations.query(on: req).all()
        }
    }
    
    func getParentsHandler(_ req: Request) throws -> Future<[Geogroup]>{
        return try req.parameters.next(Geogroup.self).flatMap(to: [Geogroup].self) { group in
            return try group.parents.query(on: req).all()
        }
    }
    
    func getChildrenHandler(_ req: Request) throws -> Future<[Geogroup]>{
        return try req.parameters.next(Geogroup.self).flatMap(to: [Geogroup].self) { group in
            return try group.children.query(on: req).all()
        }
    }
}
