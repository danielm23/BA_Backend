import Vapor

struct SchedulesController: RouteCollection {
    func boot(router: Router) throws {
        let schedulesRoute = router.grouped("api","schedules")
        schedulesRoute.get(use: getAllHandler)
        schedulesRoute.post(Schedule.self, use: createHandler)
        schedulesRoute.get(Schedule.parameter, use: getHandler)
        schedulesRoute.delete(Schedule.parameter, use: deleteHandler)
        schedulesRoute.put(Schedule.parameter, use: updateHandler)
        schedulesRoute.get(Schedule.parameter, "events", use: getEventsHandler)
        schedulesRoute.get(Schedule.parameter, "venues", use: getVenuesHandler)
        schedulesRoute.get(Schedule.parameter, "categories", use: getCategoriesHandler)
        schedulesRoute.get(Schedule.parameter, "tracks", use: getTracksHandler)
        schedulesRoute.get(Schedule.parameter, "messages", use: getMessagesHandler)
        // schedulesRoute.get(Schedule.parameter, "events", Event.parameter, "categories",use: getEventCategoriesHandler)

    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Schedule]> {
        return Schedule.query(on: req).all()
    }
    
    func createHandler(_ req: Request) throws -> Future<Schedule> {
        let schedule = try req.content.decode(Schedule.self)
        return schedule.save(on: req)
    }
    
    func createHandler(_ req: Request, schedule: Schedule) throws -> Future<Schedule> {
        return schedule.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Schedule> {
        return try req.parameters.next(Schedule.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Schedule.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Schedule> {
        return try flatMap(to: Schedule.self, req.parameters.next(Schedule.self),
                           req.content.decode(Schedule.self)) { schedule, updatedSchedule in
                            schedule.name = updatedSchedule.name
                              return schedule.save(on: req)
        }
    }
    
    func getEventsHandler(_ req: Request) throws -> Future<[Event]> {
        return try req.parameters.next(Schedule.self).flatMap(to: [Event].self){ schedule in
            return try schedule.events.query(on: req).all()
        }
    }
    
    func getCategoriesHandler(_ req: Request) throws -> Future<[Category]> {
        return try req.parameters.next(Schedule.self).flatMap(to: [Category].self){ schedule in
            return try schedule.categories.query(on: req).all()
        }
    }
    
    func getVenuesHandler(_ req: Request) throws -> Future<[Venue]> {
        return try req.parameters.next(Schedule.self).flatMap(to: [Venue].self){ schedule in
            return try schedule.venues.query(on: req).all()
        }
    }
    
    func getTracksHandler(_ req: Request) throws -> Future<[Track]> {
        return try req.parameters.next(Schedule.self).flatMap(to: [Track].self){ schedule in
            return try schedule.tracks.query(on: req).all()
        }
    }
    
    func getMessagesHandler(_ req: Request) throws -> Future<[Message]> {
        return try req.parameters.next(Schedule.self).flatMap(to: [Message].self){ schedule in
            return try schedule.messages.query(on: req).all()
        }
    }
}
