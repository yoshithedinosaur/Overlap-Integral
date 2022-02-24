//
//  Calculate Overlap.swift
//  Overlap Integral
//
//  Created by Yoshinobu Fujikake on 2/20/22.
//

import Foundation

/// Stone throwing into orbital function and weighting the guesses (weighted by multiplying value of guess in one orbital to the value of other orbital with same guess point)
/// Divide weighted total by total number of guesses to get average value
/// That average value is the integral
/// i.e., Monte-Carlo inputs to function, average value theorem to process integral

class OverlapIntegral: NSObject, ObservableObject {
        
    @MainActor @Published var functionData = [(xPoint: Double, yPoint: Double)]()
    @Published var totalGuessesString = ""
    @Published var guessesString = ""
    @Published var integralString = ""
    @Published var currentErrorString = ""
    @Published var enableButton = true
    
    var boxSize = 0.0
    var separation = 0.0
    var intervalStart = -1.0
    var intervalEnd = 1.0
    var finalVal = 0.0
    var guesses = 1
    var totalGuesses = 0
    var totalIntegral = 0.0
    var error = 0.0
    var firstTimeThroughLoop = true
    
    @MainActor init(withData data: Bool){
        
        super.init()
        
        functionData = []
        
    }
    
    /// calculate the value of the integral
    ///
    /// - Calculates the Value of exponential decay using Monte Carlo Integration
    ///
    /// - Parameter sender: Any
    func calculateIntegralTotal() async {
        
        intervalStart = -boxSize/2
        intervalEnd = boxSize/2
        
        var maxGuesses: Int = 0
        let boundingBoxCalculator = BoundingBox() ///Instantiates Class needed to calculate the area of the bounding box.
        
        let lengthOfSide1 = abs(intervalEnd-intervalStart)
        let lengthOfSide2 = abs(intervalEnd-intervalStart)
        let actualVal:Double = 1 - exp(-1) ///Actual analytical value of the integral - NEEDS CHANGING
        
        maxGuesses = guesses
        
        let newValue = await calculateMonteCarloIntegral(intervalStart: intervalStart, intervalEnd: intervalEnd, maxGuesses: maxGuesses)
        
        totalIntegral = totalIntegral + newValue
        
        totalGuesses = totalGuesses + guesses
        
        await updateTotalGuessesString(text: "\(totalGuesses)")
        
        ///Calculates the value of π from the area of a unit circle
        
        finalVal = totalIntegral/Double(totalGuesses) * boundingBoxCalculator.calculateSurfaceArea(numberOfDimensions: 2, lengthOfSide1: lengthOfSide1, lengthOfSide2: lengthOfSide2, lengthOfSide3: 0.0)
        
        error = log(abs(finalVal - actualVal))
        
        await updateCurrentErrorString(text: "\(error)")
        
        await updateFinalValString(text: "\(finalVal)")
        
       
        
    }
    
        
    /// calculateMonteCarloIntegral
    /// Parameter: intervalStart, intervalEnd, maxGuesses
    /// Return: itegralValMC
    /// This function inputs MonteCarlo data points into the function, then utilizes mean value theorem to evaluate the integral by finding the averages of each function F(c) and G(c)
/*    _
     /  b
     |    f(x) g(x)  =  F(c) G(c)
    _/  a
*/
    func calculateMonteCarloIntegral (intervalStart: Double, intervalEnd: Double, maxGuesses: Int) async -> Double {
        
        var numberOfGuesses: Int = 0
        var point = (xPoint: 0.0, yPoint: 0.0, weightVal: 0.0)
        var xRange: [Double] = [0.0, 0.0]
        var yRange: [Double] = [0.0, 0.0]
        var guessPoint1 = 0.0
        var guessPoint2 = 0.0
        var distR = 0.0
        
        xRange = [intervalStart, intervalEnd]
        yRange = [intervalStart, intervalEnd]
        
        var integralVal = 0.0
        var newFunctionPoints : [(xPoint: Double, yPoint: Double, weightVal: Double)] = []
        
        while numberOfGuesses < maxGuesses {
            point.xPoint = Double.random(in: xRange[0]...xRange[1])
            point.yPoint = Double.random(in: yRange[0]...yRange[1])
            
            //Orbital function 1
            distR = calculateDistance(xPoint: point.xPoint, yPoint: point.yPoint, separation: separation, whichOrbital: 1)
            guessPoint1 = exp(-distR) ///NEEDS TO DYNAMICALLY SWITCH BETWEEN FUNCTIONS
            
            //Orbital function 2
            distR = calculateDistance(xPoint: point.xPoint, yPoint: point.yPoint, separation: separation, whichOrbital: 2)
            guessPoint2 = exp(distR) ///NEEDS TO DYNAMICALLY SWITCH BETWEEN FUNCTIONS
            
            point.weightVal = guessPoint1 * guessPoint2
            
            newFunctionPoints.append(point)
            
            numberOfGuesses += 1
        }
        

        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        if ((totalGuesses < 500001) || (firstTimeThroughLoop)){
        
//            insideData.append(contentsOf: newInsidePoints)
//            outsideData.append(contentsOf: newOutsidePoints)
            
            var plotFunctionPoints = newFunctionPoints
            
            if (newFunctionPoints.count > 750001) {
                
                plotFunctionPoints.removeSubrange(750001..<newFunctionPoints.count)
            }
            
            await updateData(functionPoints: plotFunctionPoints)
            firstTimeThroughLoop = false
        }
        
        for item in (0...newFunctionPoints.endIndex-1) {
            
            integralVal += newFunctionPoints[item].weightVal
            
        }
        
        return integralVal
    }
    
    func calculateDistance(xPoint: Double, yPoint: Double, separation: Double, whichOrbital: Int) -> Double {
        
        var xComp = 0.0
        var yComp = 0.0
        var distR = 0.0
        
        if (whichOrbital == 1) { //Left of the x-axis
            xComp = -separation/2 + xPoint
        } else if (whichOrbital == 2) { //Right of the x-axis
            xComp = separation/2 + xPoint
        }
        yComp = yPoint
        
        distR = sqrt(yComp*yComp + xComp*xComp)
        
        return distR
        
    }
    
    
    /// updateData
    /// The function runs on the main thread so it can update the GUI
    /// - Parameters:
    ///   - insidePoints: points inside the circle of the given radius
    ///   - outsidePoints: points outside the circle of the given radius
    @MainActor func updateData(functionPoints: [(xPoint: Double, yPoint: Double, weightVal: Double)]){
        
        //functionData.append(contentsOf: functionPoints)
    }
    
    
    /// updateTotalGuessesString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the number of total guesses
    @MainActor func updateTotalGuessesString(text:String){
        
        self.totalGuessesString = text
        
    }
    
    /// updateFinalValString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of the integral
    @MainActor func updateFinalValString(text:String){
        
        self.integralString = text
        
    }
    
    /// updateCurrentErrorString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of the error
    @MainActor func updateCurrentErrorString(text:String){
        
        self.currentErrorString = text
        
    }
    
    /// setButton Enable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        
        
        if state {
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = true
                }
            }
            
            
                
        }
        else{
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = false
                }
            }
                
        }
        
    }

}
