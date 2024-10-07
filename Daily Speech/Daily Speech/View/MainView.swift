//
//  MainView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            Text("Let's practice English!")
                .font(.title)
                .foregroundColor(.mint)
            
            Spacer()
            VStack {
                HStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    NavigationLink(
                        destination: TopicView(),
                        label: {
                            Text("Start practice")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                    
                }
                
                HStack {
                    Image(systemName: "book.pages")
                    NavigationLink(
                        destination: SavedView(),
                        label: {
                            Text("Previous practice")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)})
                    
                }
            }
            .font(.title)
            Spacer()
        }
        
    }
}

#Preview {
    MainView()
}
