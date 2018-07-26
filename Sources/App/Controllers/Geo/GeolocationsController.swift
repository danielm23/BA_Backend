import Vapor

struct GeolocationsController: RouteCollection {
    
    func boot(router: Router) throws {
        let geolocationRoute = router.grouped("api","geolocations")
        geolocationRoute.get(use: getAllHandler)
        geolocationRoute.get(Geolocation.parameter, use: getHandler)
        geolocationRoute.post(Geolocation.self, use: createHandler)
        geolocationRoute.delete(Geolocation.parameter, use: deleteHandler)
    }

    func getAllHandler(_ req: Request) throws -> Future<[Geolocation]> {
        return Geolocation.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Geolocation> {
        return try req.parameters.next(Geolocation.self)
    }
    
    func createHandler(_ req: Request, geolocation: Geolocation) throws -> Future<Geolocation> {
        return geolocation.save(on: req)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Geolocation.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    /*func getInformationsHandler(_ req: Request) throws -> Future<[Geoinformation]> {
        return try req.parameters.next(Geolocation.self).flatMap(to: [Geoinformation].self) { info in
            try info.geoinformations.query(on: req).all()
        }
    }*/
}
