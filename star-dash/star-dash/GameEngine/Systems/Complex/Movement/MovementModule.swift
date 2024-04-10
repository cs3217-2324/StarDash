import Foundation

protocol MovementModule {
    var listenableEvents: [ObjectIdentifier] { get }

    func update(by deltaTime: TimeInterval)
    func handleEvent(_ event: Event) -> Event?
}
