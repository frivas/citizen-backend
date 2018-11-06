import Vapor
import Leaf

struct WebTestController: RouteCollection {
	
	var questions: [QuestionBank.Question] {
		return generateTest()
	}
	
	func boot(router: Router) throws {
		let webRoutes = router.grouped("web")
		router.get("/", use: getHome)
		webRoutes.get("prueba", use: getTest)
		webRoutes.post("checkTest", use: checkTest)
	}
	
	func getTest(_ req: Request) throws -> Future<View> {
		let context = QuestionsContext(questions: self.questions)
		return try req.view().render("ccsecitizenshiptest", context)
	}
	
	func getHome(_ req: Request) throws -> Future<View> {
		return try req.view().render("home")
	}
	
	func checkTest(_ req: Request) throws -> Future<View> {
		var answers = [String]()
		
		for question in self.questions {
			let option: Int = (try? req.content.syncGet(at: "option\(question.id)")) ?? 0
			print(option)
			
			if option == 1 {
				answers.append("\(question.id)_a")
			} else if option == 2 {
				answers.append("\(question.id)_b")
			} else if option == 3 {
				answers.append("\(question.id)_c")
			} else {
				answers.append("\(question.id)_NA")
			}
		}
		let score = getScore(answers: answers, questions: self.questions)
		let context = ["results": score]
		return try req.view().render("results", context)
	}
	
}

struct QuestionsContext: Content {
	var questions: [QuestionBank.Question]
	
}
