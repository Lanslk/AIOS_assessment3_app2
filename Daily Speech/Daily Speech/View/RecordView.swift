//
//  RecordView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI

struct RecordView: View {
    
    @Binding public var topic: String
    
    var body: some View {
        VStack {
            Text("Your Topic")
                .font(.title)
                .foregroundColor(.mint)
            Text(topic)
                .font(.title)
            Spacer()
        }
    }
}

#Preview {
    RecordView(topic: .constant("Introduce yourself"))
}
