//
//  QuestionBank.swift
//  App
//
//  Created by Francisco Rivas on 04/11/2018.
//

import Foundation
import Vapor

class QuestionHandler {
	
	var questionBank = [QuestionBank.Question]()
	let totalAmountOfQuestions: Int = 25
	
	func loadFile() -> [QuestionBank.Question] {
		let questionBankFilename = "QuestionBank.json"
		let rootDirectory = DirectoryConfig.detect().workDir
		let resourcesDirectory = URL(fileURLWithPath: "\(rootDirectory)Resources/QuestionsBank")
		let fileURL = resourcesDirectory.appendingPathComponent(questionBankFilename)
		
		let questionsBankFromFile = try! String(contentsOf: fileURL, encoding: .utf8)
		let decoder = JSONDecoder()
		let questionBankJSON = try! decoder.decode(QuestionBank.self, from: questionsBankFromFile)
		return questionBankJSON.questions
	}
	
	func generateTest() -> [QuestionBank.Question] {
		// Topic 1: 1001 - 1120 - 10 questions
		// Topic 2: 2001 - 2036 - 3 questions
		// Topic 3: 3001 - 3024 - 2 questions
		// Topic 4: 4001 - 4036 - 3 questions
		// Topic 5: 5001 - 5084 - 7 questions
		var questionsTopic = [Int]()
		let questions = loadFile()
		var generatedTest = [QuestionBank.Question]()
		
		questionsTopic += getRandomQuestionNumbers(numberOfQuestionsPerTopic: 10, questionsRanges: Array(1001...1120))
		
		questionsTopic += getRandomQuestionNumbers(numberOfQuestionsPerTopic: 3, questionsRanges: Array(2001...2036))
		
		questionsTopic += getRandomQuestionNumbers(numberOfQuestionsPerTopic: 2, questionsRanges: Array(3001...3024))
		
		questionsTopic += getRandomQuestionNumbers(numberOfQuestionsPerTopic: 3, questionsRanges: Array(4001...4036))
		
		questionsTopic += getRandomQuestionNumbers(numberOfQuestionsPerTopic: 7, questionsRanges: Array(5001...5084))
		
		for questionNumber in questionsTopic {
			generatedTest.append(questions.filter {($0.id as NSString).integerValue == questionNumber}[0])
		}
		self.questionBank = generatedTest
		return generatedTest
	}
	
	func getScore(answers: [String], questions: [QuestionBank.Question]) -> Score {
		var success: Int = 0
		var failed: Int = 0
		var unAnswered: Int = 0
		
		// Loop over the answers from the user
		for answer in answers {
			// Split user's answer as it comes <questions_id>_<answer>
			let questionNumber: Int = Int(answer.split(separator: "_")[0]) ?? 0
			let answer: String = String(answer.split(separator: "_")[1])
			
			let rightAnswers = questions.filter({Int($0.id) == questionNumber}).flatMap{$0.options}.filter{$0.id == answer && $0.isCorrect == true}
			success += rightAnswers.count
			let wrongAnswers = questions.filter({Int($0.id) == questionNumber}).flatMap{$0.options}.filter{$0.id == answer && $0.isCorrect == false}
			failed += wrongAnswers.count
			unAnswered += (answer == "NA" ? 1 : 0)
		}

		if success >= 15 {
			return Score(result: "Apto", score: success, unanswered: unAnswered, answered: (totalAmountOfQuestions-unAnswered), failed: failed)
		} else {
			return Score(result: "No Apto", score: failed, unanswered: unAnswered, answered: (totalAmountOfQuestions-unAnswered), failed: failed)
		}
	}
	
	func getRandomQuestionNumbers(numberOfQuestionsPerTopic: Int, questionsRanges: [Int]) -> [Int] {
		var resultQuestionNumbers = [Int]()
		var tempQuestionNumbersArray = questionsRanges
		
		for _ in 1...numberOfQuestionsPerTopic {
			let randomQuestionNumber = tempQuestionNumbersArray.randomElement()!
			resultQuestionNumbers.append(randomQuestionNumber)
			tempQuestionNumbersArray.remove(at: tempQuestionNumbersArray.firstIndex(of: randomQuestionNumber)!)
		}
		
		
		return resultQuestionNumbers
		
	}
	struct Score: Content {
		let result: String
		let score: Int
		let unanswered: Int
		let answered: Int
		let failed: Int
	}
}
