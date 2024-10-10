//
//  CustomRowView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI

struct CustomRowView: View {
    
    @State var buttonTitle: String
    @State var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(buttonTitle)
                
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding(.vertical, 40)
        .background(Color.blue)
        .cornerRadius(12)
        .padding()
    }
}

#Preview {
    CustomRowView(buttonTitle: "Start", imageName: "book.pages")
}
