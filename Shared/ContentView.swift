//
//  ContentView.swift
//  Shared
//
//  Created by Yoshinobu Fujikake on 2/20/22.
//

import SwiftUI

struct ContentView: View {
    
    //Set up picker variables
    @State private var orbitalSelect1 = "1s"
    @State private var orbitalSelect2 = "1s"
    let orbitalChoices = ["1s","2px"]
    
    @State var finalVal = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var guessString = "50000"
    @State var totalGuessString = "0"
    @State var integralString = "0.0"
    @State var currentErrorString = "0.0"
    @State var boxSizeString = "10.0"
    @State var separationString = "0.0"
    
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var overlap = OverlapIntegral(withData: true)
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    Text("Bounding Box size")
                        .font(.callout)
                        .bold()
                    TextField("Size of box in angstroms", text: $boxSizeString)
                }
                .padding()
                
                
                VStack {
                    Text("Number of guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Guesses", text: $guessString)
                }
                .padding()
                
                
                VStack {
                    Text("Orbitals")//left and right picker
                        .font(.callout)
                        .bold()
                    HStack {
                        Picker("Pick orbital 1:", selection: $orbitalSelect1) {
                            ForEach(orbitalChoices, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Pick orbital 2:", selection: $orbitalSelect2) {
                            ForEach(orbitalChoices, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
                .padding()
                
                
                VStack {
                    Text("Separation")
                        .font(.callout)
                        .bold()
                    TextField("Separation in angstroms", text: $separationString)
                }
                .padding()
                
                
                VStack {
                    Text("Overlap Integral")
                        .font(.callout)
                        .bold()
                    TextField("Integral value", text: $integralString)
                }
                .padding()
                
                
                VStack {
                    Text("Error (1s case only)")
                        .font(.callout)
                        .bold()
                    TextField("Error", text: $currentErrorString)
                }
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
        overlap.orbitalChoice1 = orbitalSelect1
        overlap.orbitalChoice2 = orbitalSelect2
        
        await overlap.calculateIntegralTotal()
        
        totalGuessString = overlap.totalGuessesString
        
        integralString =  overlap.integralString
        
        currentErrorString = overlap.currentErrorString
        
        overlap.setButtonEnable(state: true)
        
    }
    
    func clear(){
        
        guessString = "50000"
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
