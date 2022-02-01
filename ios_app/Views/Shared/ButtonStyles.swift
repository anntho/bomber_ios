import SwiftUI

struct TransparentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(
                minWidth: 0,
                idealWidth: 320,
                maxWidth: 320,
                minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                idealHeight: 50,
                maxHeight: 50,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
            )
            .foregroundColor(Color.accentColor)
            .cornerRadius(8)
            .font(.system(size: 15, weight: .bold))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(
                minWidth: 0,
                idealWidth: 320,
                maxWidth: 320,
                minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                idealHeight: 50,
                maxHeight: 50,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
            )
            .foregroundColor(Color.white)
            .background(Color.accentColor)
            .cornerRadius(8)
            .font(.system(size: 15, weight: .bold))
    }
}

struct RedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(
                minWidth: 0,
                idealWidth: 320,
                maxWidth: 320,
                minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                idealHeight: 50,
                maxHeight: 50,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
            )
            .foregroundColor(Color.white)
            .background(Color.red)
            .cornerRadius(8)
            .font(.system(size: 15, weight: .bold))
    }
}

struct GreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(
                minWidth: 0,
                idealWidth: 320,
                maxWidth: 320,
                minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                idealHeight: 50,
                maxHeight: 50,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
            )
            .foregroundColor(Color.white)
            .background(Color.green)
            .cornerRadius(8)
            .font(.system(size: 15, weight: .bold))
    }
}

struct RadioSelected: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(
                minWidth: 0,
                idealWidth: 320,
                maxWidth: 320,
                minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                idealHeight: 50,
                maxHeight: 50,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
            )
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color.white)
            .background(Color.accentColor)
            .cornerRadius(8)
    }
}

struct RadioNotSelected: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(
                minWidth: 0,
                idealWidth: 320,
                maxWidth: 320,
                minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                idealHeight: 50,
                maxHeight: 50,
                alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
            )
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(Color.gray)
            .background(Color(white: 0.9))
            .cornerRadius(8)
    }
}
