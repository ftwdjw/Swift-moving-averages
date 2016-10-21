//: moving averages

import UIKit
import Accelerate


//extension converts to a string with 2 place accuracy for easier reading
extension Double {
    
    var convertToString: String {return self.asSinglePrecisionString()}
    
    func asSinglePrecisionString() -> String {
        let strOfNumber = String(format: "%4.2f", self)
        return strOfNumber
    }
}


let PI = 3.14159265359.convertToString

PI




func round1( a: [Double]) -> [String]  {
    //this function used with extension to make double arrays easier to read
     var result = [String](repeating:"", count:a.count)
    
    for i in (0..<a.count){
     result[i] = a[i].convertToString
    }
    
    return result
    }

let randomArraySize = 20
let doubleRandoms = (1...randomArraySize).map { _ in Double (arc4random()) }
print("double random numbers= \(doubleRandoms)\n")

func normalize (a: [Double]) -> (out:[Double], mean1:Double, std:Double) {
    //Compute mean and standard deviation and then calculate new elements to have a zero mean and a unit standard deviation. Double precision.
    var mean = 0.0
    var standardDeviation = 0.0
    //this is only for initialization. not setting anything
    
    var result = [Double](repeating:0.0, count:a.count)
    vDSP_normalizeD(a, 1,&result, 1, &mean, &standardDeviation, UInt(a.count))
    return (out:result, mean1:mean, std:standardDeviation)
}

let normRandom =  normalize(a: doubleRandoms)

let out1=round1(a: normRandom.out)

print("normalized random numbers= \(out1)\n")


func movingAverage (a:[Double], numberSum: Int) -> [Double]
{
    var result = [Double](repeating:0.0, count:a.count)
    var sum:Double = 0.0
    for index in (0..<a.count){
        
        if index<numberSum{
        result[index]=a[index]
        }
        else{
            sum=0.0
            for k in (0..<numberSum){
            sum=sum+a[index-k]
            }
            result[index]=sum/Double(numberSum)
        }
    }
    
    
    return result
}

func sub (a: [Double], b: [Double]) -> [Double] {
    //This function subtracts the first N elements of A - B and leaves the result in C. This function subtracts the first N elements of B from A and leaves the result in C.
    
    assert(a.count == b.count, "Expected arrays of the same length, instead got arrays of two different lengths")
    
    var result = [Double](repeating:0.0, count:a.count)
    vDSP_vsubD(a, 1, b, 1, &result, 1, UInt(a.count))
    return result
}


let averagedNumbers = movingAverage(a: normRandom.out, numberSum: 5)

let out2=round1(a: averagedNumbers)

print("moving averaged numbers= \(out2)\n")

let difference1 = sub(a: normRandom.out, b: averagedNumbers)

let out3=round1(a: difference1)

print("differences= \(out3)\n")

