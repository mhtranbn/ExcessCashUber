//
//	ResponseOCR.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ResponseOCR : Codable {

	let isErroredOnProcessing : Bool?
	let oCRExitCode : Int?
	let parsedResults : [ParsedResult]?
	let processingTimeInMilliseconds : String?
	let searchablePDFURL : String?


	enum CodingKeys: String, CodingKey {
		case isErroredOnProcessing = "IsErroredOnProcessing"
		case oCRExitCode = "OCRExitCode"
		case parsedResults = "ParsedResults"
		case processingTimeInMilliseconds = "ProcessingTimeInMilliseconds"
		case searchablePDFURL = "SearchablePDFURL"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		isErroredOnProcessing = try values.decodeIfPresent(Bool.self, forKey: .isErroredOnProcessing)
		oCRExitCode = try values.decodeIfPresent(Int.self, forKey: .oCRExitCode)
		parsedResults = try values.decodeIfPresent([ParsedResult].self, forKey: .parsedResults)
		processingTimeInMilliseconds = try values.decodeIfPresent(String.self, forKey: .processingTimeInMilliseconds)
		searchablePDFURL = try values.decodeIfPresent(String.self, forKey: .searchablePDFURL)
	}


}
