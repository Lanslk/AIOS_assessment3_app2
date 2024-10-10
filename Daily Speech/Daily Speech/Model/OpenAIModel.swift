//
//  OpenAIModel.swift
//  Daily Speech
//
//  Created by yuteng Lan on 7/10/2024.
//

import SwiftUI
import Foundation

struct Message: Codable {
    let role: String
    let content: String
}

struct ChatGPTRequest: Codable {
    let model: String
    let messages: [Message]
}

struct ChatGPTResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

func sendChatGPTRequest(message: String, completion: @escaping (String?) -> Void) {
    let openAIKey = ""
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    // Configure the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
    
    //print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
    //print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
    
    // Create the message to send
    let userMessage = Message(role: "user", content: message)
    let chatRequest = ChatGPTRequest(model: "gpt-3.5-turbo", messages: [userMessage])
    
    do {
        let requestData = try JSONEncoder().encode(chatRequest)
        request.httpBody = requestData
    } catch {
        print("Failed to encode request: \(error)")
        return
    }
    
    // Send the request
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Failed to receive response: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        // Decode the response
        do {
            let chatResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
            let responseMessage = chatResponse.choices.first?.message.content
            completion(responseMessage)
        } catch {
            print("Failed to decode response: \(error)")
            completion(nil)
        }
    }.resume()
}
