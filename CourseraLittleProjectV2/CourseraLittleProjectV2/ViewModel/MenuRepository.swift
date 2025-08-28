//
//  MenuRepository.swift
//

import Foundation
import SwiftData

@MainActor
final class MenuRepository {
    private let api: MenuAPI
    private let url: URL

    init(api: MenuAPI = DefaultMenuAPI(), url: URL = menuURL) {
        self.api = api
        self.url = url
    }

    func sync(context: ModelContext) async throws {
        let dtos = try await api.fetchMenu(from: url)

        // 1) Категории (upsert по name)
        let categoryNames = Set(dtos.map { prettyCategoryName($0.category) })
        let existingCats = try fetchCategories(byNames: categoryNames, context: context)
        var catByName = Dictionary(uniqueKeysWithValues: existingCats.map { ($0.name, $0) })

        for name in categoryNames where catByName[name] == nil {
            let c = Category(name: name)
            context.insert(c)
            catByName[name] = c
        }

        // 2) Индекс существующих блюд по ключу title|category
        let existingItems = try context.fetch(FetchDescriptor<MenuItem>())
        var itemByKey: [String: MenuItem] = [:]
        for item in existingItems {
            let key = itemKey(title: item.title, categoryName: item.category?.name ?? "")
            itemByKey[key] = item
        }

        // 3) Upsert каждого блюда
        for dto in dtos {
            let catName = prettyCategoryName(dto.category)
            guard let cat = catByName[catName] else { continue }

            let key = itemKey(title: dto.title, categoryName: catName)
            let priceValue = Float(dto.price) ?? 0
            let imgURL = URL(string: dto.image)

            if let exist = itemByKey[key] {
                exist.title = dto.title
                exist.details = dto.description
                exist.price  = priceValue
                exist.imageURL = imgURL
                if exist.dateAdded == nil { exist.dateAdded = Date() }
                exist.category = cat
            } else {
                let item = MenuItem(
                    id: UUID(),                      // локальный UUID
                    title: dto.title,
                    details: dto.description,
                    price: priceValue,
                    imageURL: imgURL,
                    dateAdded: Date(),
                    isFavorite: false,
                    category: cat
                )
                context.insert(item)
                itemByKey[key] = item
            }
        }

        try context.save()
    }

    // MARK: - Helpers

    private func prettyCategoryName(_ raw: String) -> String {
        guard let first = raw.first else { return raw }
        return String(first).uppercased() + raw.dropFirst()
    }

    private func itemKey(title: String, categoryName: String) -> String {
        "\(title.lowercased())|\(categoryName.lowercased())"
    }

    private func fetchCategories(byNames names: Set<String>, context: ModelContext) throws -> [Category] {
        guard !names.isEmpty else { return [] }
        let pred = #Predicate<Category> { names.contains($0.name) }
        return try context.fetch(FetchDescriptor<Category>(predicate: pred))
    }
}
