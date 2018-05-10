import Vapor

struct TagsController: RouteCollection {
    func boot(router: Router) throws {
        let tagsRoute = router.grouped("api","tags")
        tagsRoute.get(use: getAllHandler)
        tagsRoute.post(Tag.self, use: createHandler)
        tagsRoute.get(Venue.parameter, use: getHandler)
        tagsRoute.delete(Venue.parameter, use: deleteHandler)
        tagsRoute.put(Venue.parameter, use: updateHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Tag]> {
        return Tag.query(on: req).all()
    }
    
    func createHandler(_ req: Request, tag: Tag) throws -> Future<Tag> {
        return tag.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Tag> {
        return try req.parameters.next(Tag.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Tag.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Tag> {
        return try flatMap(to: Tag.self,
                           req.parameters.next(Tag.self),
                           req.content.decode(Tag.self)) { tag, updatedTag in
                            tag.name = updatedTag.name
                            tag.color = updatedTag.color
                            tag.scheduleId = updatedTag.scheduleId
                            return tag.save(on: req)
        }
    }
    func optionsHandler(_ req: Request) throws -> HTTPStatus {
        return HTTPStatus.ok
    }
}
