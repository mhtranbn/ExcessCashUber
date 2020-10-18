//
//	TextOverlay.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct TextOverlay : Codable {

	let hasOverlay : Bool?
	let lines : [Line]?
	let message : String?


	enum CodingKeys: String, CodingKey {
		case hasOverlay = "HasOverlay"
		case lines = "Lines"
		case message = "Message"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		hasOverlay = try values.decodeIfPresent(Bool.self, forKey: .hasOverlay)
		lines = try values.decodeIfPresent([Line].self, forKey: .lines)
		message = try values.decodeIfPresent(String.self, forKey: .message)
	}


}