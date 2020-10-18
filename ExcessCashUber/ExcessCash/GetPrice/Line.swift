//
//	Line.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Line : Codable {

	let lineText : String?
	let maxHeight : Float?
	let minTop : Float?
	let words : [Word]?


	enum CodingKeys: String, CodingKey {
		case lineText = "LineText"
		case maxHeight = "MaxHeight"
		case minTop = "MinTop"
		case words = "Words"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		lineText = try values.decodeIfPresent(String.self, forKey: .lineText)
		maxHeight = try values.decodeIfPresent(Float.self, forKey: .maxHeight)
		minTop = try values.decodeIfPresent(Float.self, forKey: .minTop)
		words = try values.decodeIfPresent([Word].self, forKey: .words)
	}


}