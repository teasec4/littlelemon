//
//  MenuDTO.swift
//

import Foundation

// Точный JSON:
// {
//   "menu": [
//     { "id": 1, "title": "...", "description": "...", "price": "10", "image": "https://...", "category": "starters" },
//     ...
//   ]
// }

struct MenuResponseDTO: Decodable {
    let menu: [MenuItemDTO]
}

struct MenuItemDTO: Decodable {
    let id: Int                 // число в JSON
    let title: String
    let description: String
    let price: String           // строка "10"
    let image: String           // строковый URL
    let category: String        // "starters" | "mains" | "desserts" ...
}
