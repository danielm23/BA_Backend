import Vapor

struct VenuesController: RouteCollection {
    func boot(router: Router) throws {
        let venuesRoute = router.grouped("api","venues")
        venuesRoute.get(use: getAllHandler)
        venuesRoute.post(Venue.self, use: createHandler)
        venuesRoute.get(Venue.parameter, use: getHandler)
        venuesRoute.delete(Venue.parameter, use: deleteHandler)
        venuesRoute.put(Venue.parameter, use: updateHandler)
        venuesRoute.get(Venue.parameter, "events", use: getEventsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Venue]> {
        return Venue.query(on: req).all()
    }
    
    func createHandler(_ req: Request) throws -> Future<Venue> {
        let venue = try req.content.decode(Venue.self)
        return venue.save(on: req)
    }
    
    func createHandler(_ req: Request, venue: Venue) throws -> Future<Venue> {
        return venue.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Venue> {
        return try req.parameters.next(Venue.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Venue.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Venue> {
        return try flatMap(to: Venue.self,
                        req.parameters.next(Venue.self),
                        req.content.decode(Venue.self)) { venue, updatedVenue in
                        venue.name = updatedVenue.name
                        venue.scheduleId = updatedVenue.scheduleId
        return venue.save(on: req)
        }
    }
    
    func getEventsHandler(_ req: Request) throws -> Future<[Event]> {
        return try req.parameters.next(Venue.self).flatMap(to: [Event].self){ venue in
            return try venue.events.query(on: req).all()
        }
    }
}

