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
    /*
    router.get("search") { req -> Future<String> in
        return req.withPooledConnection(to: .psql) { conn in
            return try conn.query("select * from geosearch;").map(to: String.self)
            /*{ rows in
                print(rows)
                return try rows[0].firstValue(tableOID: id, name: "title")?.decode(String.self) ?? "n/a"
            }*/
        }
    }*/
    
    
   
    let searchTerm: String = "mensa"
    
    router.get("results", searchTerm: String) { req -> Future<[GeoSearchResult]> in
        return req.requestPooledConnection(to: .psql).flatMap { conn -> EventLoopFuture<[GeoSearchResult]> in
            defer { try? req.releasePooledConnection(conn, to: .psql) }
            let fq = FluentQuery()
                .select(\GeoSearchResult.id, as: "id")
                .select(\GeoSearchResult.title, as: "title")
                .from(GeoSearchResult.self)
                .where(FQWhere("\"_geosearchresult_\".document @@ to_tsquery('german', '\(searchTerm)')"))
            return try fq
                .execute(on: conn)
                .decode(GeoSearchResult.self)
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
