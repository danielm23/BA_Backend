import Vapor

struct EventsController: RouteCollection {
    func boot(router: Router) throws {
        let eventsRoute = router.grouped("api","events")
        eventsRoute.get(use: getAllHandler)
        eventsRoute.post(Event.self, use: createHandler)
        eventsRoute.get(Event.parameter, use: getHandler)
        eventsRoute.delete(Event.parameter, use: deleteHandler)
        eventsRoute.put(Event.parameter, use: updateHandler)
        eventsRoute.get(Event.parameter, "schedule", use: getScheduleHandler)
        eventsRoute.get(Event.parameter, "categories", use: getCategoriesHandler)
        eventsRoute.post(Event.parameter, "categories", Category.parameter, use: addCategoriesHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Event]> {
        return Event.query(on: req).all()
    }
    
    func createHandler(_ req: Request, event: Event) throws -> Future<Event> {
        return event.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Event> {
        return try req.parameters.next(Event.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Event.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Event> {
        return try flatMap(to: Event.self,
                           req.parameters.next(Event.self),
                           req.content.decode(Event.self)) { event, updatedEvent in
                            event.name = updatedEvent.name
                            event.startDate = updatedEvent.startDate
                            event.endDate = updatedEvent.endDate
                            event.scheduleId = updatedEvent.scheduleId
                            event.venueId = updatedEvent.venueId
                            return event.save(on: req)
        }
    }
    
    func getScheduleHandler(_ req: Request) throws -> Future<Schedule>{
        return try req.parameters.next(Event.self).flatMap(to: Schedule.self) { event in
            return try event.schedule.get(on: req)
        }
    }
    
    func getCategoriesHandler(_ req: Request) throws -> Future<[Category]>{
        return try req.parameters.next(Event.self).flatMap(to: [Category].self) { event in
            return try event.categories.query(on: req).all()
        }
    }
    
    /*func addLocationHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Geoinformation.self), req.parameters.next(Geolocation.self)) { info, location in
            let pivot = try GeoinformationForGeolocation(info.requireID(), location.requireID())
            return pivot.save(on: req).transform(to: .created)
        }
    }*/
    
    func addCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Event.self), req.parameters.next(Category.self)) { event, category in
            let pivot = try EventCategoryPivot(event.requireID(), category.requireID())
            return pivot.save(on: req).transform(to: .created)
        }
    }
}
