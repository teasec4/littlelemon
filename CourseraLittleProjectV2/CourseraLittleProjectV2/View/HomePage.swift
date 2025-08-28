//
//  HomePage.swift
//  CourseraLittleProjectV2
//


import SwiftUI
import SwiftData

struct HomePage: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [Profile]
    
    // Живые запросы к SwiftData
    @Query(sort: [SortDescriptor(\Category.name, order: .forward)])
    private var categories: [Category]
    
    @Query(sort: [SortDescriptor(\MenuItem.title, order: .forward)])
    private var allItems: [MenuItem]
    
    @State private var search = ""
    @State private var selectedCategory: Category? = nil
    @State private var isLoading = false
    @State private var error: String?
    
    private let repo = MenuRepository()
    
    // Фильтр для списка
    private var filteredItems: [MenuItem] {
        allItems.filter { item in
            // Категория
            let catOK: Bool = {
                guard let sel = selectedCategory else { return true }
                return item.category?.id == sel.id
            }()
            
            // Поиск
            if search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return catOK
            }
            let q = search.lowercased()
            let inTitle = item.title.lowercased().contains(q)
            let inDetails = (item.details ?? "").lowercased().contains(q)
            return catOK && (inTitle || inDetails)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header с логотипом и профилем
            HStack {
                LogoHeader()
                Spacer()
                if let profile = profiles.first {
                    NavigationLink {
                        ProfileView(profile: profile) // ← теперь редактируем SwiftData объект
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .resizable().frame(width: 36, height: 36)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Баннер + поиск
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.sRGB, red: 58/255, green: 85/255, blue: 74/255, opacity: 1))
                VStack(alignment: .leading, spacing: 12) {
                    Text("Little Lemon")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(Color.yellow)
                    Text("Chicago")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.9))
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.subheadline)
                        .lineLimit(3)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                        TextField("Search menu", text: $search)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(12)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .padding()
            
            // Категории + refresh
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("ORDER FOR DELIVERY!")
                        .font(.title3).bold()
                    Spacer()
                    if isLoading { ProgressView().scaleEffect(0.8) }
                    Button {
                        Task { await refresh() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isLoading)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryChip(
                            title: "All",
                            isSelected: selectedCategory == nil
                        ) { selectedCategory = nil }
                        
                        ForEach(categories, id: \.id) { cat in
                            CategoryChip(
                                title: cat.name,
                                isSelected: selectedCategory?.id == cat.id
                            ) { selectedCategory = cat }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 8)
            
            if let error {
                Text(error).foregroundStyle(.red).padding(.horizontal)
            }
            
            // Список блюд
            List(filteredItems, id: \.id) { item in
                MenuRow(item: item)
            }
            .listStyle(.plain)
        }
        // При первом запуске — тянем меню
        .task { await initialLoadIfNeeded() }
    }
    
    // MARK: - Loading
    
    private func initialLoadIfNeeded() async {
        if allItems.isEmpty {
            await refresh()
        }
    }
    
    private func refresh() async {
        error = nil
        isLoading = true
        do {
            try await repo.sync(context: context)
        } catch {
            self.error = "Failed to fetch menu: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

struct MenuRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFill()
                case .failure(_): Color.gray.opacity(0.2)
                case .empty: ProgressView()
                @unknown default: Color.gray.opacity(0.2)
                }
            }
            .frame(width: 80, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title).font(.headline)
                if let details = item.details {
                    Text(details)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline.bold())
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.bold())
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundStyle(.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct LogoHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "leaf.fill")
                .foregroundStyle(.yellow)
            Text("LITTLE LEMON")
                .font(.headline).bold()
        }
    }
}

#Preview {
    HomePage()
}
