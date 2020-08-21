import SwiftUI

struct TestSmallView: View {
    private let placeholder = "placeholder"
    var body: some View {
        VStack {
            HStack {
                Image("BQB1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image("BQB2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding([.top, .leading, .trailing])
            HStack{
                Image("BQB3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image("BQB4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
        }
    }
}

struct TestMediumView {
    private let placeholder = "placeholder"
    var body: some View {
        Text(placeholder)
    }
}

struct TestLargeView {
    private let placeholder = "placeholder"
    var body: some View {
        HStack {
            List {
                Text("One")
                
                Text("Two")
                
                Text("Three")
                
            }.listStyle(GroupedListStyle())
        }
    }
}
