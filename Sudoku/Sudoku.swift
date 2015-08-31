//
//  Sudoku.swift
//  Sudoku
//
//  Created by Olof Moriya on 28/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

class Sudoku{
    var data:[Int] = []
    
    init(){
        data = Array<Int>(count: 81, repeatedValue: 0)
    }
    
    init?(string:String){
        for char in string{
            if let int = String(char).toInt(){
                data.append(int)
            }else{
                data.append(0)
            }
        }
        
        if data.count != 81{
            data = []
            return nil
        }
    }
    
    func copy()->Sudoku{
        var copy = Sudoku()
        copy.data = data
        return copy
    }
    
    func nextEmptyIndex()->Int?{
        for i in 0...80{
            if data[i] == 0{
                return i
            }
        }
        return nil
    }
    
    func printSudoku(){
        var output = ""
        for i in 0...8{
            for j in 0...8{
                output = "\(output)\(data[j+(9*i)])"
            }
            output = "\(output)\n"
        }
        println(output)
    }
    
    func sum()->Int{
        var sum = 0
        for value in data{
            sum += value
        }
        return sum
    }
    
    func dataIndexFromCoord(#x:Int, y:Int)->Int{
        return x + y*9
    }
    
    func inversOfValues(values:[Int])->[Int]{
        var inverse: [Int:Bool] = [:]
        for i in 1...9{
            inverse[i] = true
        }
        
        for value in values{
            inverse[value] = nil
        }
        
        return inverse.keys.array
    }
    
    func unionOfArrays(arrays:[[Int]])->[Int]?{
        if arrays.count < 2{
            return nil
        }
        
        var union:[Int] = []
        
        for value in arrays[0]{
            var existInAllArrays = true
            for i in 1..<arrays.count{
                if !contains(arrays[i], value){
                    existInAllArrays = false
                    break
                }
            }
            if existInAllArrays{
                union.append(value)
            }
        }
        return union
    }
    
    func isValueValidInCoord(#value: Int, inX x:Int, andY y:Int)->Bool{
        if value < 1 || value > 9{
            return false
        }
        
        if let validValues = validValuesForCoord(x: x, y: y){
            return contains(validValues, value)
        } else{
            return false
        }
    }
    
    func invalidNumbersForCoord(#x:Int, y:Int)->[Int]?{
        if !isValidCoord(x: x, y: y){
            return nil
        }
        
        if let row = valuesInRow(y), col = valuesInColumn(x), squareIndex = squareIndexOfCoord(inX: x, andY: y), square = valuesInSquare(squareIndex){
            let illigalValues = row + col + square
            return uniq(illigalValues)
        }
        else {
            return nil
        }
    }
    
    func isValidCoord(#x:Int, y:Int)->Bool{
        return !(x < 0 || x > 8 || y < 0 || y > 8)
    }
    
    func validValuesForCoord(#x:Int, y:Int)->[Int]?{
        if !isValidCoord(x: x, y: y){
            return nil
        }
        
        if data[dataIndexFromCoord(x: x, y: y)] != 0{
            return []
        }
        
        if let invalidNumbers = invalidNumbersForCoord(x: x, y: y){
            return inversOfValues(invalidNumbers)
        }else{
            return nil
        }
    }
    
    func valuesInRow(row:Int)->[Int]?{
        if row < 0 || row > 8{
            return nil
        }
        
        var values:[Int] = []
        let start = row*9
        for i in start...start+8{
            if data[i] != 0{
                values.append(data[i])
            }
        }
        return values
    }
    
    func valuesInColumn(col:Int)->[Int]?{
        if col < 0 || col > 8{
            return nil
        }
        var values:[Int] = []
        
        for i in 0...8{
            if data[i*9 + col] != 0{
                values.append(data[i*9 + col])
            }
        }
        return values
    }
    
    func squareIndexOfCoord(inX x:Int, andY y: Int)->Int?{
        if !isValidCoord(x:x, y: y) {
            return nil
        }
        return x/3 + y/3 * 3
    }
    
    func valuesInSquare(index:Int)->[Int]?{
        if index < 0 || index > 8{
            return nil
        }
        
        var values:[Int] = []
        
        let x = index%3*3
        let y = index/3*3
        
        for i in x...x+2{
            for j in y...y+2{
                if data[j*9 + i] != 0 {
                    values.append(data[j*9 + i])
                }
            }
        }
        
        return values
    }
}