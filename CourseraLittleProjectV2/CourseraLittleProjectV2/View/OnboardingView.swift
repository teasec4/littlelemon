//
//  OnboardingView.swift
//  CourseraLittleProjectV2
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName  = ""
    @State private var email     = ""
    @State private var phone     = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LogoHeader()

                Text("Welcome to Little Lemon")
                    .font(.largeTitle).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                GroupBox {
                    VStack(spacing: 16) {
                        LabeledTextField(title: "First name", text: $firstName, placeholder: "Your first name")
                        LabeledTextField(title: "Last name",  text: $lastName,  placeholder: "Your last name")
                        LabeledTextField(title: "Email",      text: $email,     placeholder: "name@example.com", keyboard: .emailAddress)
                        LabeledTextField(title: "Phone",      text: $phone,     placeholder: "(000) 000-0000", keyboard: .phonePad)
                    }
                    .padding(.vertical, 8)
                }

                Button(action: createProfile) {
                    Text("Get started")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? Color.yellow : Color.gray.opacity(0.3))
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!isValid)

                Text("We’ll save your profile locally. You can edit it anytime in Profile.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func createProfile() {
        // Значения по умолчанию для уведомлений:
        // wantsOrderStatuses: true
        // wantsPasswordChanges: true
        // wantsSpecialOffers: true
        // wantsNewsletter: false
        let profile = Profile(
            firstName: firstName,
            lastName:  lastName,
            email:     email,
            phone:     phone,
            wantsOrderStatuses:   true,
            wantsPasswordChanges: true,
            wantsSpecialOffers:   true,
            wantsNewsletter:      false
        )
        context.insert(profile)
        do {
            try context.save()
            dismiss()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }
}

// MARK: - Small helper

struct LabeledTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.footnote).foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [Profile.self], inMemory: true)
}
