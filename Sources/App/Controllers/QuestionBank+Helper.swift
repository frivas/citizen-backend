//
//  QuestionBank.swift
//  App
//
//  Created by Francisco Rivas on 04/11/2018.
//

import Foundation
import Vapor

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
	
	for _ in 1...10{
		questionsTopic.append(Int.random(in: 1001...1120))
	}
	for _ in 1...3{
		questionsTopic.append(Int.random(in: 2001...2036))
	}
	for _ in 1...2{
		questionsTopic.append(Int.random(in: 3001...3024))
	}
	for _ in 1...3{
		questionsTopic.append(Int.random(in: 4001...4036))
	}
	for _ in 1...7{
		questionsTopic.append(Int.random(in: 5001...5084))
	}
	for item in questions {
		if questionsTopic.contains((item.id as NSString).integerValue) {
			generatedTest.append(item)
		}
	}
	return generatedTest
}

func getScore(answers: [String], questions: [QuestionBank.Question]) -> Score {
	var success: Int = 0
	
	for answer in answers {
		for question in questions {
			let questionNumber: Int = Int(answer.split(separator: "_")[0]) ?? 0
			let answer: String = String(answer.split(separator: "_")[1])
			
			if questionNumber == Int(question.id) {
				if answer == question.answer {
					success += 1
				}
			}
		}
	}
	if success >= 15 {
		return Score(result: "Apto", score: success)
	} else {
		
		return Score(result: "No Apto", score: (25-success))
	}
}

struct Score: Content {
	let result: String
	let score: Int
}

