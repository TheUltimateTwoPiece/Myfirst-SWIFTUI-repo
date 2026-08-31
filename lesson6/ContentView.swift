//
//  ContentView.swift
//  lesson6
//
//  Created by Kakarla Hemanth Reddy on 31/8/26.
//
// abel was here
// me too
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "banana")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("banana!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
