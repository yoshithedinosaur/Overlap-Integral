//
//  Orbital Functions.swift
//  Overlap Integral
//
//  Created by Yoshinobu Fujikake on 2/20/22.
//

import Foundation

class Orbitals: NSObject, ObservableObject {
    
    let a_nought = 0.5292
    
    func callOrbitalFunc(orbitalChoice: String, paramterVals: (r: Double, theta: Double, phi: Double)) -> Double {
        switch orbitalChoice {
        case "1s":
            return one_s_Orbital(parameterVals: paramterVals)
        case "2px":
            return two_px_Orbital(parameterVals: paramterVals)
        default:
            print("Not implemented yet.")
            return 0.0
        }
    }
    
    
    func one_s_Orbital(parameterVals: (r: Double, theta: Double, phi: Double)) -> Double {
        var waveFuncVal = 0.0
        var coeffVal = 0.0
        
        coeffVal = 1 / (sqrt(Double.pi) * pow(a_nought, 1.5))
        waveFuncVal = coeffVal * exp(-parameterVals.r / a_nought)
        
        return waveFuncVal
    }
    
    
    
    func two_px_Orbital(parameterVals: (r: Double, theta: Double, phi: Double)) -> Double {
        var waveFuncVal = 0.0
        var coeffVal = 0.0
        
        coeffVal = 1 / (4 * sqrt(2*Double.pi) * pow(a_nought, 2.5))
        waveFuncVal = coeffVal * parameterVals.r * exp(-parameterVals.r / (2*a_nought)) * sin(parameterVals.theta) * cos(parameterVals.phi)
        
        return waveFuncVal
    }
}
