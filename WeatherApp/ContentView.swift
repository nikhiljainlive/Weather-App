//
//  ContentView.swift
//  WeatherApp
//
//  Created by Admin on 10/05/21.
//

import SwiftUI

struct ContentView: View {
    @State private var input : String = ""
    
    @ObservedObject var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter city", text: $input, onEditingChanged: { (_) in
            }, onCommit: {
                if !self.input.isEmpty {
                    self.weatherViewModel.fetch(city: self.input)
                }
            })
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Divider()
            Text(weatherViewModel.weatherInfo).font(.body)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
