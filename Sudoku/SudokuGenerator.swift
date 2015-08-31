//
//  SudokuGenerator.swift
//  Sudoku
//
//  Created by Olof Moriya on 30/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

class SudokuGenerator: NSObject {
    let sudokuBase = "EAFGBIDHCHGCDAFIBEIDBHCEGFACIHEGDFABBEGIFACDHAFDBHCEGIDCAFIHBEGFBIAEGHCDGHECDBAIF"
    let baseChars:[String] = ["A","B","C","D","E","F","G","H","I"]
    
    func generateCompleteSudoku() -> Sudoku{
        var shuffledBaseChar = shuffle(baseChars)
        var newSudokuString = sudokuBase
        for i in 0..<shuffledBaseChar.count{
            newSudokuString = newSudokuString.stringByReplacingOccurrencesOfString(shuffledBaseChar[i], withString: "\(i+1)", options: NSStringCompareOptions.allZeros, range: nil)
        }
        var sudoku = Sudoku(string: newSudokuString)!
        return sudoku
    }

    func generateEasySudoku()->Sudoku{
        let solver = SudokuSolver()
        
        var sudoku = generateCompleteSudoku()
        var result = 405
        var unique = true
        while result == 405 && unique{
            var randomIndex = Int(arc4random_uniform(UInt32(80)))
            var removedValue = sudoku.data[randomIndex]
            sudoku.data[randomIndex] = 0
            
            var sudokuCopy = sudoku.copy()
            var uniqueTest = sudoku.copy()
            
            solver.soleCandidate(sudokuCopy)
            result = sudokuCopy.sum()
            
            if result != 405 || !unique{
                //Reset the last set value because the sudoku can't be solved
                sudoku.data[randomIndex] = removedValue
            }
        }
        
        return sudoku
    }
    
    func generateHardSudoku()->Sudoku{
        let solver = SudokuSolver()
        
        var sudoku = generateMediumSudoku()
        var result = 405
        var unique = true
        
        while (result == 405 && unique) || filter(sudoku.data, { (value) -> Bool in return value != 0}).count > 25{
            var randomIndex = Int(arc4random_uniform(UInt32(80)))
            var removedValue = sudoku.data[randomIndex]
            sudoku.data[randomIndex] = 0
            
            var sudokuCopy = sudoku.copy()
            var uniqueTest = sudoku.copy()
            
            solver.solve(sudokuCopy)
            solver.backtrack(sudokuCopy,ignoreSolutions: [])
            result = sudokuCopy.sum()
            
            solver.backtrack(uniqueTest,ignoreSolutions: [sudokuCopy])
            unique = uniqueTest.sum() != 405
            
            if result != 405 || !unique{
                //Reset the last set value because the sudoku can't be solved
                sudoku.data[randomIndex] = removedValue
            }
        }
        
        return sudoku
    }
    
    func generateMediumSudoku()->Sudoku{
        let solver = SudokuSolver()
        
        var sudoku = generateEasySudoku()
        var result = 405
        
        while result == 405 || filter(sudoku.data, { (value) -> Bool in return value != 0}).count > 26{
            var randomIndex = Int(arc4random_uniform(UInt32(80)))
            var removedValue = sudoku.data[randomIndex]
            sudoku.data[randomIndex] = 0
            
            var sudokuCopy = sudoku.copy()
            
            solver.solve(sudokuCopy)
            result = sudokuCopy.sum()
            
            if result != 405{
                //Reset the last set value because the sudoku can't be solved
                sudoku.data[randomIndex] = removedValue
            }
        }
        
        return sudoku
    }
}
