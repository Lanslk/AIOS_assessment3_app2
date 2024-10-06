//
//  ContentView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Daily Speech")
                    .foregroundColor(.mint)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                NavigationLink(
                    destination: MainView(),
                    label: {
                        Text("Sign in")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                .padding()
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
