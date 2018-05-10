import Vapor

struct OrteController: RouteCollection {
    func boot(router: Router) throws {
        let orteRoute = router.grouped("api","orte")
        orteRoute.get(use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Orte]> {
        return Orte.query(on: req).all()
    }
}

