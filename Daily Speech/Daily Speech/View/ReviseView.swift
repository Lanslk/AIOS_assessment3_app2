//
//  ReviseView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI

struct ReviseView: View {
    @Binding public var content: String
    
    var body: some View {
        Text(content)
    }
}

#Preview {
    ReviseView(content: .constant("Introduce yourself"))
}
