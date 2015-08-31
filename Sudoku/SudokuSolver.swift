//
//  SudokuSolver.swift
//  Sudoku
//
//  Created by Olof Moriya on 28/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

class SudokuSolver: NSObject {

    static func coordFromIndex(index:Int)->(x:Int, y:Int){
        return (index%9, index/9)
    }
    
    func isSameSolution(a:[Int], b:[Int])->Bool{
        for i in 0...80{
            if a[i] != b[i]{
                return false
            }
        }
        return true
    }
    
    func solve(sudoku:Sudoku)->Bool{
        var currentSum = 0
        while currentSum != sudoku.sum(){
            currentSum = sudoku.sum()
            
            soleCandidate(sudoku)
            dubbleRowDubbleColumn(sudoku)
            uniquePerRow(sudoku)
            nakedSubset(sudoku)
        }
        return currentSum == 405
    }

    func backtrack(sudoku:Sudoku, ignoreSolutions:[Sudoku])->(solved: Bool, result: Sudoku?){
        
        if let i = sudoku.nextEmptyIndex(){
            var coord = SudokuSolver.coordFromIndex(i)
            for value in sudoku.validValuesForCoord(x:coord.x, y: coord.y)!{
                sudoku.data[i] = value
                var result = backtrack(sudoku, ignoreSolutions:ignoreSolutions)
                if result.solved{
                    var unique = true
                    for solution in ignoreSolutions{
                        if isSameSolution(sudoku.data, b: solution.data){
                            unique = false
                        }
                    }
                    if unique{
                        return result
                    }
                }
                sudoku.data[i] = 0
            }
        }else{
            return (true,sudoku)
        }
        
        return (false,nil)
    }
    
    func soleCandidate(sudoku:Sudoku){
        var failedCount = 0
        var index = 0
        while failedCount <= 81{
            let coord = SudokuSolver.coordFromIndex(index)
            if let values = sudoku.validValuesForCoord(x: coord.x, y: coord.y) where values.count == 1{
                sudoku.data[index] = values[0]
                failedCount = 0
            }else{
                failedCount++
            }
            index = (index + 1) % 81
        }
    }
    
    func dubbleRowDubbleColumn(sudoku:Sudoku){
        for i in 0...8{
            var validValuesInSquare = sudoku.inversOfValues(sudoku.valuesInSquare(i)!)
            
            for value in validValuesInSquare{
                let xStart = i%3*3
                let yStart = i/3*3
                
                
                var available: [Bool] = Array(count: 9, repeatedValue: true)
                
                
                for step in 0...2{
                    //rows
                    if contains(sudoku.valuesInRow(yStart + step)!, value){
                        available[(step*3)...(step*3)+2] = ArraySlice(count: 3, repeatedValue: false)
                    }
                    //columns
                    if contains(sudoku.valuesInColumn(xStart + step)!, value){
                        for multiplier in 0...2{
                            available[step + multiplier*3] = false
                        }
                    }
                }
                //taken spots
                for i in 0...2{
                    for j in 0...2{
                        if sudoku.data[sudoku.dataIndexFromCoord(x: xStart + i, y: yStart + j)] != 0{
                            available[i + j*3] = false
                        }
                    }
                }
                
                var availableCount = filter(available, { (val) -> Bool in
                    return val
                }).count
                if availableCount == 1{
                    for i in 0...2{
                        for j in 0...2{
                            if available[i + j*3]{
                                sudoku.data[sudoku.dataIndexFromCoord(x: xStart + i, y: yStart + j)] = value
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func uniquePerRow(sudoku:Sudoku){
        for i in 0...8{
            var validValuesInRow = sudoku.inversOfValues(sudoku.valuesInRow(i)!)
            
            for value in validValuesInRow{
                let y = i
                
                var available: [Bool] = Array(count: 9, repeatedValue: true)

                //taken spots
                for i in 0...8{
                    if sudoku.data[sudoku.dataIndexFromCoord(x: i, y: y)] != 0{
                        available[i] = false
                    }
                }
                
                //column
                for i in 0...8{
                    if contains(sudoku.valuesInColumn(i)!,value){
                        available[i] = false
                    }
                }
                
                //sqaure
                //could be made to jump steps of three...
                for i in 0...8{
                    if contains(sudoku.valuesInSquare(sudoku.squareIndexOfCoord(inX: i, andY: y)!)!,value){
                        available[i] = false
                    }
                }
            
                var availableCount = filter(available, { (val) -> Bool in
                    return val
                }).count
                if availableCount == 1{

                    for i in 0...8{
                        if available[i]{
                            sudoku.data[sudoku.dataIndexFromCoord(x: i, y: y)] = value
                        }
                    }

                }
                
            }
        }
    }
    
    func nakedSubset(sudoku:Sudoku){
        for y in 0...8{
            
            var availableValuesPerField:[[Int]] = Array<[Int]>(count: 9, repeatedValue: [])
            for x in 0...8{
                availableValuesPerField[x] = sudoku.validValuesForCoord(x: x, y: y)!
            }
            
            var availableFieldsCount = filter(availableValuesPerField, { (array) -> Bool in
                return array.count > 0
            }).count
            
            if availableFieldsCount > 2{
                
                for count in 2...availableFieldsCount{
                    var found:Int = 0
                    for a in 0..<availableValuesPerField.count{
                        if availableValuesPerField[a].count < 2{
                            continue
                        }
                        for b in 0..<availableValuesPerField.count{
                            if a == b {
                                continue
                            }
                            if availableValuesPerField[a].count != count || availableValuesPerField[b].count != count{
                                continue
                            }
                            
                            if Utils.arraysAreEqual(a: availableValuesPerField[a], b: availableValuesPerField[b]){
                                found++
                            }
                        }
                        if found >= count{
                            for i in 0..<availableValuesPerField.count{
                                if availableValuesPerField[i].count == count + 1{
                                    var uniqueValues:[Int] = []
                                    for value in availableValuesPerField[i]{
                                        if !contains(availableValuesPerField[a], value){
                                            uniqueValues.append(value)
                                        }
                                    }
                                    if uniqueValues.count == 1{
                                        sudoku.data[sudoku.dataIndexFromCoord(x: i, y: y)] = uniqueValues[0]
                                        nakedSubset(sudoku)
                                        return
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
    }
}
