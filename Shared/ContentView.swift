//
//  ContentView.swift
//  Shared
//
//  Created by Yoshinobu Fujikake on 2/20/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var finalVal = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var guessString = "23458"
    @State var totalGuessString = "0"
    @State var integralString = "0.0"
    @State var currentErrorString = "0.0"
    @State var boxSizeString = "1.0"
    @State var separationString = "0.0"
    
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var overlap = OverlapIntegral(withData: true)
    
    var body: some View {
        HStack {
            VStack {
                Text("Bounding Box size")
                    .padding()
                
                Text("Number of guesses")
                    .padding()
                
                Text("Orbitals")//left and right picker
                    .padding()
                
                Text("Separation")
                
                Text("Overlap Integral")
                    .padding()
                
                Text("Error")
                    .padding()
                
                Button("Cycle Calculation", action: {Task.init{await self.calculateIntegralVal()}})
                    .padding()
                    .disabled(overlap.enableButton == false)
                
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    .disabled(overlap.enableButton == false)
                
                if (!overlap.enableButton){
                    
                    ProgressView()
                }
            }
        }
    }
    
    func calculateIntegralVal() async {
        
        
        overlap.setButtonEnable(state: false)
        
        overlap.guesses = Int(guessString)!
        overlap.boxSize = Double(boxSizeString)!
        overlap.separation = Double(separationString)!
        overlap.totalGuesses = Int(totalGuessString) ?? Int(0.0)
        
        await overlap.calculateIntegralTotal()
        
        totalGuessString = overlap.totalGuessesString
        
        integralString =  overlap.integralString
        
        currentErrorString = overlap.currentErrorString
        
        overlap.setButtonEnable(state: true)
        
    }
    
    func clear(){
        
        guessString = "23458"
        totalGuessString = "0.0"
        integralString =  ""
        overlap.totalGuesses = 0
        overlap.totalIntegral = 0.0
        overlap.functionData = []
        overlap.firstTimeThroughLoop = true
        currentErrorString = ""
        
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
