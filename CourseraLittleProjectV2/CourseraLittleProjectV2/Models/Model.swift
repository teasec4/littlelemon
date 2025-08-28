//
//  MenuItem.swift
//  CourseraLittleProjectV2
//
//  Created by Максим Ковалев on 8/27/25.
//
import Foundation
import SwiftData




let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!

@Model
final class Category{
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
}

@Model
final class MenuItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String?
    var price: Float
    var imageURL: URL?
    var dateAdded: Date?
    var isFavorite: Bool?
    var category: Category?
    
    init(id: UUID = UUID(), title: String, details: String? = nil, price: Float, imageURL: URL? = nil, dateAdded: Date? = nil, isFavorite: Bool? = nil, category: Category? = nil) {
        self.id = id
        self.title = title
        self.details = details
        self.price = price
        self.imageURL = imageURL
        self.dateAdded = dateAdded
        self.isFavorite = isFavorite
        self.category = category
    }
}


@Model
final class Profile {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var wantsOrderStatuses: Bool
    var wantsPasswordChanges: Bool
    var wantsSpecialOffers: Bool
    var wantsNewsletter: Bool

    init(firstName: String = "", lastName: String = "", email: String = "", phone: String = "",
         wantsOrderStatuses: Bool = true, wantsPasswordChanges: Bool = true,
         wantsSpecialOffers: Bool = true, wantsNewsletter: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.wantsOrderStatuses = wantsOrderStatuses
        self.wantsPasswordChanges = wantsPasswordChanges
        self.wantsSpecialOffers = wantsSpecialOffers
        self.wantsNewsletter = wantsNewsletter
    }
}


