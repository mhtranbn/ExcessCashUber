//
//	Word.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Word : Codable {

	let height : Float?
	let left : Float?
	let top : Float?
	let width : Float?
	let wordText : String?


	enum CodingKeys: String, CodingKey {
		case height = "Height"
		case left = "Left"
		case top = "Top"
		case width = "Width"
		case wordText = "WordText"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		height = try values.decodeIfPresent(Float.self, forKey: .height)
		left = try values.decodeIfPresent(Float.self, forKey: .left)
		top = try values.decodeIfPresent(Float.self, forKey: .top)
		width = try values.decodeIfPresent(Float.self, forKey: .width)
		wordText = try values.decodeIfPresent(String.self, forKey: .wordText)
	}


}