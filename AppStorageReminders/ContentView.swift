//
//  ContentView.swift
//  AppStorageReminders
//
//  Created by Andrei Gorbunov on 07.02.2024.
//

import SwiftUI

enum FocusText {
    case title
}

struct ContentView: View {
    @AppStorage("reminders") private var reminders: [String] = ["Первый", "Второй"]
    @FocusState private var focusField: FocusText?
    
    var body: some View {
        VStack(alignment: .trailing) {
            NavigationView {
                List {
                    ForEach(reminders.indices, id: \.self) { index in
                        HStack {
                            Image(systemName: "circle")
                            TextField("", text: $reminders[index])
                                .focused($focusField, equals: .title)
                        }
                    }
                    .onDelete(perform: remove)
                }
                .listStyle(.plain)
                .toolbar {
                    EditButton()
                }
            }
            Button("", systemImage: "plus") {
                reminders.append("Новое напоминание")
                focusField = .title
            }
        }
    }
    
    func remove(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}



extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}

#Preview {
    ContentView()
}
