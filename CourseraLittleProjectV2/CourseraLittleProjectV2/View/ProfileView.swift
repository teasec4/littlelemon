//
//  ProfileView.swift
//  CourseraLittleProjectV2
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var profile: Profile // SwiftData объект

    var body: some View {
        Form {
            Section("Personal information") {
                TextField("First name", text: $profile.firstName)
                TextField("Last name",  text: $profile.lastName)
                TextField("Email",      text: $profile.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                TextField("Phone",      text: $profile.phone)
                    .keyboardType(.phonePad)
            }

            Section("Email notifications") {
                Toggle("Order statuses",   isOn: $profile.wantsOrderStatuses)
                Toggle("Password changes", isOn: $profile.wantsPasswordChanges)
                Toggle("Special offers",   isOn: $profile.wantsSpecialOffers)
                Toggle("Newsletter",       isOn: $profile.wantsNewsletter)
            }

            Section {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text("Close")
                }
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    let profile = Profile(firstName: "Tilly", lastName: "Doe", email: "tilly@example.com", phone: "555-0101")
    return ProfileView(profile: profile)
        .modelContainer(for: [Profile.self], inMemory: true)
}
