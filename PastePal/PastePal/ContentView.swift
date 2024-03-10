import SwiftUI


struct ContentView: View {
    @ObservedObject private var pastePalManager = PastePalManager()
    @State private var deletionConfirmation: ClipboardItem?

    var body: some View {
        NavigationView {
            VStack {
                Text("PastePal - Clipboard Manager")
                    .font(.title)
                    .padding()

                TextField("Search", text: $pastePalManager.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List {
                    ForEach(pastePalManager.filteredItems) { item in
                        NavigationLink(destination: PasteDetailView(item: item)) {
                            HStack {
                                Text(item.content)
                                    .font(.body)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)

                                Spacer()

                                Button(action: {
                                    pastePalManager.copyToClipboard(item.content)
                                }) {
                                    Image(systemName: "doc.on.clipboard.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(BorderlessButtonStyle())

                                Button(action: {
                                    deletionConfirmation = item
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(VisualEffectBlur())
                .cornerRadius(20)
                .alert(item: $deletionConfirmation) { item in
                    Alert(
                        title: Text("Delete Item"),
                        message: Text("Are you sure you want to delete this item?"),
                        primaryButton: .destructive(Text("Delete")) {
                            pastePalManager.deleteClipboardItem(item)
                        },
                        secondaryButton: .cancel()
                    )
                }

                Button("Clear Clipboard History") {
                    pastePalManager.clearClipboard()
                }
                .padding()
            }
            .padding()
            .frame(width: 400, height: 500)
        }
    }
}
