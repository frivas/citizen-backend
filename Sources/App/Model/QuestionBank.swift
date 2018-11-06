//
//  QuestionBank.swift
//  App
//
//  Created by Francisco Rivas on 04/11/2018.
//

import Foundation
import Vapor

struct QuestionBank: Content {
	struct Question: Content {
		var id: String
		var questionText: String
		var options = [String:String]()
		var answer: String
	}
	let questions: [Question]
}
