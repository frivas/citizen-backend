import Routing
import Vapor
import Foundation
import Leaf

public func routes(_ router: Router) throws {
	
	let testController = TestController()
	try router.register(collection: testController)
	
	let webTestController = WebTestController()
	try router.register(collection: webTestController)
}
