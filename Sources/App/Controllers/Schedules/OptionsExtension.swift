import Foundation
import Routing

extension Client {
    /// Sends a OPTIONS request with body
    public func options(_ url: URLRepresentable, headers: HTTPHeaders = .init()) -> Future<Response> {
        return send(.OPTIONS
            , headers: headers, to: url)
    }
}

extension Router {
    @discardableResult
    public func options<T>(
        _ path: DynamicPathComponentRepresentable...,
        use closure: @escaping RouteResponder<T>.Closure
        ) -> Route<Responder> where T: ResponseEncodable {
        return self.on(.OPTIONS, at: path.makeDynamicPathComponents(), use: closure)
    }
}
