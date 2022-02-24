//
//  Bounding Box.swift
//  Overlap Integral
//
//  Created by Yoshinobu Fujikake on 2/23/22.
//

import Foundation

class BoundingBox: ObservableObject {
    
    /// calculateSurfaceArea
    /// Parameters: numberOfDimensions, lengthOfSide1, lengthOfSide2, lengthOfSide3
    /// Return: surfaceArea
    /// Given the dimensions and lengths of each side, this function will calcualte the surface area of the bounding box
    func calculateSurfaceArea (numberOfDimensions: Int, lengthOfSide1: Double, lengthOfSide2: Double, lengthOfSide3: Double) -> Double {
        var surfaceArea = 0.0
        
        /// Stupid-proof check so that it doesn't matter which side length is 0
        switch numberOfDimensions {
        case 2:
            if(min(lengthOfSide1,lengthOfSide2,lengthOfSide3) == 0.0){
                surfaceArea = lengthOfSide1*lengthOfSide2 + lengthOfSide1*lengthOfSide3 + lengthOfSide2*lengthOfSide3
            } else {
                print("Number of dimensions and number of sides do not match.")
            }
            
        case 3:
            surfaceArea = 2*lengthOfSide1*lengthOfSide2 + 2*lengthOfSide1*lengthOfSide3 + 2*lengthOfSide2*lengthOfSide3
        default:
            print("This number of dimensions is not supported.")
        }
        
        return surfaceArea
    }
    
    
    /// calcualteVolume
    /// Parameters: lengthOfSide1, lengthOfSide2, lengthOfSide3
    /// Return: volume
    /// Given the side lengths, this function will calculate the volume of the bounding box. Only matters for 3D.
    func calculateVolume (lengthOfSide1: Double, lengthOfSide2: Double, lengthOfSide3: Double) -> Double {
        var volume = 0.0
        
        volume = lengthOfSide1 * lengthOfSide2 * lengthOfSide3
        
        return volume
    }
}

