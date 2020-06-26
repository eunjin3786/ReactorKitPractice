import Foundation

protocol ServiceProviderProtocol: class {
    var userService: UserServiceProtocol { get }
}

final class ServiceProvider: ServiceProviderProtocol {
    lazy var userService: UserServiceProtocol = UserService(provider: self)
}
