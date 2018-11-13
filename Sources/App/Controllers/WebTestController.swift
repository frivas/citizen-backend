import Vapor
import Leaf

struct WebTestController: RouteCollection {
	
	var questions = QuestionHandler()
	
	func boot(router: Router) throws {
		let webRoutes = router.grouped("web")
		router.get("/", use: getHome)
		webRoutes.get("prueba", use: getTest)
		webRoutes.post("checkTest", use: checkTest)
	}
	
	func getTest(_ req: Request) throws -> Future<View> {
		let testQuestions = questions.generateTest()
		let context = QuestionsContext(questions: testQuestions)
		return try req.view().render("ccsecitizenshiptest", context)
	}
	
	func getHome(_ req: Request) throws -> Future<View> {
		return try req.view().render("home")
	}
	
	func checkTest(_ req: Request) throws -> Future<View> {
		var answers = [String]()
		
		for question in questions.questionBank {
			let selectedAnswer: String = (try? req.content.syncGet(at: "option\(question.id)")) ?? ""
			
			if selectedAnswer == "a" {
				answers.append("\(question.id)_a")
			} else if selectedAnswer == "b" {
				answers.append("\(question.id)_b")
			} else if selectedAnswer == "c" {
				answers.append("\(question.id)_c")
			} else {
				answers.append("\(question.id)_NA")
			}
		}
		let score = self.questions.getScore(answers: answers, questions: self.questions.questionBank)
		let context = ["results": score]
		return try req.view().render("results", context)
	}
	
}

struct QuestionsContext: Content {
	var questions: [QuestionBank.Question]
	
}
