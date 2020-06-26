class BaseService {
  unowned let provider: ServiceProviderProtocol

  init(provider: ServiceProviderProtocol) {
    self.provider = provider
  }
}
