//
//  Sudoku.swift
//  Sudoku
//
//  Created by Olof Moriya on 28/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

public class Sudoku{
    public var data:[Int] = []
    
    public init(){
        data = Array<Int>(count: 81, repeatedValue: 0)
    }
    
    public init?(string:String){
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
    
    //MARK: Static helpers
    
    static func coordFromIndex(index:Int)->(x:Int, y:Int){
        return (index%9, index/9)
    }
    
    static func dataIndexFromCoord(#x:Int, y:Int)->Int{
        return x + y*9
    }
    
    static func squareIndexOfCoord(inX x:Int, andY y: Int)->Int?{
        if !Sudoku.isValidCoord(x:x, y:y) {
            return nil
        }
        return x/3 + y/3 * 3
    }

    static func isValidCoord(#x:Int, y:Int)->Bool{
        return !(x < 0 || x > 8 || y < 0 || y > 8)
    }
    
    static func inversOfValues(values:[Int])->[Int]{
        var inverse: [Int:Bool] = [:]
        for i in 1...9{
            inverse[i] = true
        }
        
        for value in values{
            inverse[value] = nil
        }
        
        return inverse.keys.array
    }
    
    static func copy(sudoku:Sudoku)->Sudoku{
        var copy = Sudoku()
        copy.data = sudoku.data
        return copy
    }
    
    //MARK: Data Helpers
    
    public func nextEmptyIndex()->Int?{
        for i in 0...80{
            if data[i] == 0{
                return i
            }
        }
        return nil
    }
    
    public func isValueValidInCoord(#value: Int, inX x:Int, andY y:Int)->Bool{
        if value < 1 || value > 9{
            return false
        }
        
        if let validValues = validValuesForCoord(x: x, y: y){
            return contains(validValues, value)
        } else{
            return false
        }
    }
    
    public func invalidNumbersForCoord(#x:Int, y:Int)->[Int]?{
        if !Sudoku.isValidCoord(x: x, y: y){
            return nil
        }
        
        if let row = valuesInRow(y), col = valuesInColumn(x), squareIndex = Sudoku.squareIndexOfCoord(inX: x, andY: y), square = valuesInSquare(squareIndex){
            let illigalValues = row + col + square
            return uniq(illigalValues)
        }
        else {
            return nil
        }
    }
    
    public func validValuesForCoord(#x:Int, y:Int)->[Int]?{
        if !Sudoku.isValidCoord(x: x, y: y){
            return nil
        }
        
        if data[Sudoku.dataIndexFromCoord(x: x, y: y)] != 0{
            return []
        }
        
        if let invalidNumbers = invalidNumbersForCoord(x: x, y: y){
            return Sudoku.inversOfValues(invalidNumbers)
        }else{
            return nil
        }
    }
    
    public func valuesInRow(row:Int)->[Int]?{
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
    
    public func valuesInColumn(col:Int)->[Int]?{
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
    
    public func valuesInSquare(index:Int)->[Int]?{
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
    
    //MARK: Validation
    
    public func sum()->Int{
        var sum = 0
        for value in data{
            sum += value
        }
        return sum
    }
    
    public func validate()->Bool{
        if sum() != 405 {
            return false
        }
        
        let testNumbers = [1,2,3,4,5,6,7,8,9]
        //test rows
        for i in 0...8{
            var numbers:[Int] = []
            for j in 0...8{
                numbers.append(data[j + i*9])
            }
            var containsEveryNumber = true
            for number in testNumbers{
                containsEveryNumber = containsEveryNumber && contains(numbers, number)
            }
            if !containsEveryNumber{
                return false
            }
        }
        //test columns
        for i in 0...8{
            var numbers:[Int] = []
            for j in 0...8{
                numbers.append(data[j*9 + i])
            }
            var containsEveryNumber = true
            for number in testNumbers{
                containsEveryNumber = containsEveryNumber && contains(numbers, number)
            }
            if !containsEveryNumber{
                return false
            }
        }
        //test squares
        for square in 0...8{
            var numbers:[Int] = []
            for y in 0...2{
                for x in 0...2{
                    numbers.append(data[x + y*9 + (square / 3) * 27])
                }
            }
            var containsEveryNumber = true
            for number in testNumbers{
                containsEveryNumber = containsEveryNumber && contains(numbers, number)
            }
            if !containsEveryNumber{
                return false
            }
        }
        return true
    }
    
    //MARK: Log Helpers
    
    func printSudokuLog(){
        var output = ""
        for i in 0...8{
            for j in 0...8{
                output = "\(output)\(data[j+(9*i)])"
            }
            output = "\(output)\n"
        }
        println(output)
    }
}