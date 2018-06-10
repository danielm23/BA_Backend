import Vapor

struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("api","categories")
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.post(Category.self, use: createHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {
        return category.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Category> {
        return try req.parameters.next(Category.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Category.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Category> {
        return try flatMap(to: Category.self,
                           req.parameters.next(Category.self),
                           req.content.decode(Category.self)) { category, updatedCategory in
                            category.name = updatedCategory.name
                            category.color = updatedCategory.color
                            category.scheduleId = updatedCategory.scheduleId
                            return category.save(on: req)
        }
    }
}
