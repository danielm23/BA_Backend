import Routing
import Vapor
import FluentPostgreSQL

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("firstgeoinformation") { req -> Future<String> in
        return req.withPooledConnection(to: .psql) { conn in
            return try conn.query("select title from geo_overview;").map(to: String.self) { rows in
                print(rows)
                return try rows[0].firstValue(forColumn: "title")?.decode(String.self) ?? "n/a"
            }
        }
    }
    
    let eventsController = EventsController()
    try router.register(collection: eventsController)
    
    let schedulesController = SchedulesController()
    try router.register(collection: schedulesController)
    
    let venuesController = VenuesController()
    try router.register(collection: venuesController)
    
    let tagsController = TagsController()
    try router.register(collection: tagsController)
    
    let geolocationsController = GeolocationsController()
    try router.register(collection: geolocationsController)
    
    let geoinformationsController = GeoinformationsController()
    try router.register(collection: geoinformationsController)
    
    let geogroupsController = GeogroupsController()
    try router.register(collection: geogroupsController)
}
