import Vapor
import Leaf

struct TestController: RouteCollection {
	
	let questions = QuestionHandler()
	
	func boot(router: Router) throws {
		router.get("api", "prueba/json/", use: getTestJSON)
	}
	
	func getTestJSON(_ req: Request) throws -> Future<[QuestionBank.Question]> {
		return Future.map(on: req) { return self.questions.generateTest() }
	}
	

}
