//
//  MenuAPI.swift
//

import Foundation

protocol MenuAPI {
    func fetchMenu(from url: URL) async throws -> [MenuItemDTO]
}

struct DefaultMenuAPI: MenuAPI {
    func fetchMenu(from url: URL) async throws -> [MenuItemDTO] {
        // без кэша, чтобы видеть обновления сразу
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let root = try JSONDecoder().decode(MenuResponseDTO.self, from: data)
        return root.menu
    }
}
