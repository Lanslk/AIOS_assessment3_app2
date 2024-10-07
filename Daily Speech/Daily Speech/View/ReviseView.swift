//
//  ReviseView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI

struct ReviseView: View {
    @Binding public var origin: String
    @Binding public var content: String
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Revise your speech")
                    .font(.title)
                    .foregroundColor(.mint)
                
                Spacer()
                
                ScrollView {
                    Text("Original")
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(.blue)
                    
                    TextEditor(text: $origin)
                        .padding()
                        .frame(minHeight: 200, maxHeight: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                .padding()
                
                ScrollView {
                    Text("Revised")
                        .font(.title)
                        .padding(.bottom, 5)
                        .foregroundColor(.green)
                    
                    TextEditor(text: $content)
                        .padding()
                        .frame(minHeight: 200, maxHeight: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                .padding()
                
                Text("Save")
            }
            
        }
    }
}

#Preview {
    ReviseView(origin: .constant("Introducing yourself"), content: .constant("Introduce yourself"))
}
