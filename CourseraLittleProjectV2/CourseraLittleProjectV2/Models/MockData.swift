//
//  MockData.swift
//  CourseraLittleProjectV2
//

import Foundation

// Используем твои модели как типы, но НИЧЕГО не сохраняем в БД.
// Просто создаём инстансы в памяти.

let mockCategories: [Category] = [
    Category(name: "Starters"),
    Category(name: "Mains"),
    Category(name: "Desserts"),
    Category(name: "Drinks")
]

let mockItems: [MenuItem] = [
    MenuItem(
        title: "Greek Salad",
        details: "Crisp lettuce, tomatoes, cucumbers, olives, and feta cheese.",
        price: 12.99,
        imageURL: URL(string: "https://picsum.photos/seed/greek/300/200"),
        dateAdded: Date(),
        isFavorite: true,
        category: mockCategories[0]
    ),
    MenuItem(
        title: "Bruschetta",
        details: "Grilled bread with garlic and tomato.",
        price: 7.99,
        imageURL: URL(string: "https://picsum.photos/seed/brus/300/200"),
        dateAdded: Date().addingTimeInterval(-3600*24),
        isFavorite: false,
        category: mockCategories[0]
    ),
    MenuItem(
        title: "Grilled Fish",
        details: "Sea bass with herbs and lemon.",
        price: 18.49,
        imageURL: URL(string: "https://picsum.photos/seed/fish/300/200"),
        dateAdded: Date().addingTimeInterval(-3600*32),
        isFavorite: false,
        category: mockCategories[1]
    ),
    MenuItem(
        title: "Pasta al Limone",
        details: "Creamy lemon pasta with parmesan.",
        price: 15.99,
        imageURL: URL(string: "https://picsum.photos/seed/pasta/300/200"),
        dateAdded: Date().addingTimeInterval(-3600*60),
        isFavorite: nil,
        category: mockCategories[1]
    ),
    MenuItem(
        title: "Tiramisu",
        details: "Classic coffee-flavored dessert.",
        price: 8.49,
        imageURL: URL(string: "https://picsum.photos/seed/tira/300/200"),
        dateAdded: Date().addingTimeInterval(-3600*72),
        isFavorite: false,
        category: mockCategories[2]
    ),
    MenuItem(
        title: "Iced Tea",
        details: "Freshly brewed tea with lemon.",
        price: 3.99,
        imageURL: URL(string: "https://picsum.photos/seed/tea/300/200"),
        dateAdded: Date().addingTimeInterval(-3600*10),
        isFavorite: nil,
        category: mockCategories[3]
    )
]

// Мок-профиль (для стартового заполнения экрана профиля).
let mockProfile = Profile(
    firstName: "Tilly",
    lastName: "Doe",
    email: "tillydoe@example.com",
    phone: "(217) 555-0113",
    wantsOrderStatuses: true,
    wantsPasswordChanges: true,
    wantsSpecialOffers: true,
    wantsNewsletter: true
)
