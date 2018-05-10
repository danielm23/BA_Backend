import Vapor

struct GeogroupsController: RouteCollection {
    
    func boot(router: Router) throws {
        let geogroupRoute = router.grouped("api","geogroups")
        geogroupRoute.get(use: getAllHandler)
        geogroupRoute.post(Geogroup.self, use: createHandler)
        geogroupRoute.delete(Geogroup.parameter, use: deleteHandler)
        geogroupRoute.get(Geolocation.parameter, "infos", use: getInformationsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Geogroup]> {
        return Geogroup.query(on: req).all()
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
}
