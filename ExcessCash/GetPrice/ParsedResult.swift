//
//	ParsedResult.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ParsedResult : Codable {

	let errorDetails : String?
	let errorMessage : String?
	let fileParseExitCode : Int?
	let parsedText : String?
	let textOrientation : String?
	let textOverlay : TextOverlay?


	enum CodingKeys: String, CodingKey {
		case errorDetails = "ErrorDetails"
		case errorMessage = "ErrorMessage"
		case fileParseExitCode = "FileParseExitCode"
		case parsedText = "ParsedText"
		case textOrientation = "TextOrientation"
		case textOverlay = "TextOverlay"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		errorDetails = try values.decodeIfPresent(String.self, forKey: .errorDetails)
		errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
		fileParseExitCode = try values.decodeIfPresent(Int.self, forKey: .fileParseExitCode)
		parsedText = try values.decodeIfPresent(String.self, forKey: .parsedText)
		textOrientation = try values.decodeIfPresent(String.self, forKey: .textOrientation)
        textOverlay = try values.decodeIfPresent(TextOverlay.self, forKey: .textOverlay)
	}


}
