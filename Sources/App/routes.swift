import Routing
import Vapor
import FluentPostgreSQL
import FluentQuery

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    struct ResultsRequest: Codable {
        var searchTerm: String
    }
    
    // example: http://localhost:8080/api/geosearch?searchTerm=philo
    router.get("api", "geosearch") { req -> Future<[GeoOverview]> in
        
        let query = try req.query.decode(ResultsRequest.self)
        let searchTerm = query.searchTerm
        
        return req.requestPooledConnection(to: .psql).flatMap { conn -> EventLoopFuture<[GeoOverview]> in
            defer { try? req.releasePooledConnection(conn, to: .psql) }
            let fq = FluentQuery()
                .select("*")
                .from(GeoOverview.self)
                .where(FQWhere(\GeoOverview.document ~~~ ["german", "\(searchTerm)"]))
            return try fq
                .execute(on: conn)
                .decode(GeoOverview.self)
        }
    }
    
    struct ScheduleRequest: Codable {
        var scheduleId: String
    }
    
    router.get("api", "geooverviews") { req -> Future<[GeoOverview]> in
        
        let query = try req.query.decode(ScheduleRequest.self)
        let schdeduleId = query.scheduleId
        
        return req.requestPooledConnection(to: .psql).flatMap { conn -> EventLoopFuture<[GeoOverview]> in
            defer { try? req.releasePooledConnection(conn, to: .psql) }
            let fq = FluentQuery()
                .select(all: Venue.self)
                .from(Venue.self)
                //.join(.left, Schedule.self, where: \Schedule.id == \Venue.scheduleId)
                .join(.left, GeoOverview.self, where: \GeoOverview.id == \Venue.id)
                //.where(FQWhere(\Schedule.id == "schdeduleId"))
            return try fq
                .execute(on: conn)
                .decode(GeoOverview.self)
        }
    }
    
    let eventsController = EventsController()
    try router.register(collection: eventsController)
    
    let schedulesController = SchedulesController()
    try router.register(collection: schedulesController)
    
    let venuesController = VenuesController()
    try router.register(collection: venuesController)
    
    let categoriesController = CategoriesController()
    try router.register(collection: categoriesController)
    
    let geolocationsController = GeolocationsController()
    try router.register(collection: geolocationsController)
    
    let geoinformationsController = GeoinformationsController()
    try router.register(collection: geoinformationsController)
    
    let geogroupsController = GeogroupsController()
    try router.register(collection: geogroupsController)
}
