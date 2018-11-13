//
//  QuestionBank.swift
//  App
//
//  Created by Francisco Rivas on 04/11/2018.
//

import Foundation
import Vapor

public struct QuestionBank: Content {
	public struct Question: Content {
		var id: String
		var question: String
		var options = [Options]()
	}
	
	public struct Options: Content {
		var id: String
		var option: String
		var isCorrect: Bool
	}
	public let questions: [Question]
}
