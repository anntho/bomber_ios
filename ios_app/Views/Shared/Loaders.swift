import SwiftUI

struct Loader: View {
    @Binding var isLoading: Bool

    var body: some View {
        if isLoading {
            VStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                    .scaleEffect(1.5, anchor: .center)
                Spacer()
            }
            .zIndex(1)
            .frame(
                maxWidth: 200,
                maxHeight: 200,
                alignment: .center
            )
            .background(Color.white)
            .opacity(0.7)
            .cornerRadius(8)
        }
    }
}
