//
//  MainView.swift
//  Daily Speech
//
//  Created by yuteng Lan on 6/10/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userAccount: UserAccount
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Let's practice English!")
                    .font(.title)
                    .foregroundColor(.mint)
                
                Spacer()
                HStack {
                    NavigationLink(
                        destination: TopicView()
                            .environmentObject(userAccount),
                        label: {
                            CustomRowView(buttonTitle: "Start practice", imageName: "rectangle.and.pencil.and.ellipsis")
                            })
                    
                }

                HStack {
                    NavigationLink(
                        destination: SavedView()
                            .environmentObject(userAccount),
                        label: {
                            CustomRowView(buttonTitle: "Previous practice", imageName: "book.pages")
                        })
                    
                }
                Spacer()
            }
            .font(.title)
            Spacer()
        }
        
    }
}

#Preview {
    MainView()
}
