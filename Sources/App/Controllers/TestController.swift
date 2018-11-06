import Vapor
import Leaf

struct TestController: RouteCollection {
	
	var questions: [QuestionBank.Question] {
		return generateTest()
	}
	
	func boot(router: Router) throws {
		router.get("api", "prueba/json/", use: getTestJSON)

	}
	
	func getTestJSON(_ req: Request) throws -> Future<[QuestionBank.Question]> {
		return Future.map(on: req) { return self.questions }
	}
	

}
