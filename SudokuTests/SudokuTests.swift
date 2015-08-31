//
//  SudokuTests.swift
//  SudokuTests
//
//  Created by Olof Olsson on 28/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit
import XCTest
import Sudoku

class SudokuTests: XCTestCase {
    
    var sudoku:Sudoku?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFailableInit(){
        var sudokuString = "7...9...32..468..1..8...6...4..2..9....3.4....8..1..3...9...7..5..142..68...5...21"
        XCTAssertNil(Sudoku(string: sudokuString), "Should have returned nil for to long string")
        
        sudokuString = "7...9...32..468..1..8...6...4..2..9....3.4....8..1..3...9...7..5..142..68...5..."
        XCTAssertNil(Sudoku(string: sudokuString), "Should have returned nil for to short string")
    }
    
    func testNumbersInRow(){
        var sudokuString = "7...9...32..468..1..8...6...4..2..9....3.4....8..1..3...9...7..5..142..68...5...2"
        var sudoku = Sudoku(string: sudokuString)!
        
        var values = sudoku.valuesInRow(-1)
        XCTAssertNil(values, "Should have returned nil row index -1")
        
        values = sudoku.valuesInRow(0)
        XCTAssertEqual(values!.count, 3, "Row should only contain 3 values")
        XCTAssertTrue(contains(values!, 7), "Row should contain 7")
        XCTAssertTrue(contains(values!, 9), "Row should contain 9")
        XCTAssertTrue(contains(values!, 3), "Row should contain 3")
    }
    
    func testNumbersInCol(){
        var sudokuString = "7...9...32..468..1..8...6...4..2..9....3.4....8..1..3...9...7..5..142..68...5...2"
        var sudoku = Sudoku(string: sudokuString)!
        
        var values = sudoku.valuesInColumn(10)
        XCTAssertNil(values, "Should have returned nil col index 10")
        
        values = sudoku.valuesInColumn(0)
        XCTAssertEqual(values!.count, 4, "Col should only contain 4 values")
        XCTAssertTrue(contains(values!, 7), "Col should contain 7")
        XCTAssertTrue(contains(values!, 2), "Col should contain 2")
        XCTAssertTrue(contains(values!, 5), "Col should contain 5")
        XCTAssertTrue(contains(values!, 8), "Col should contain 8")
    }
    
    func testNumbersInSquare(){
        var sudokuString = "7...9...32..468..1..8...6...4..2..9....3.4....8..1..3...9...7..5..142..68...5...2"
        var sudoku = Sudoku(string: sudokuString)!
        
        var values = sudoku.valuesInSquare(9)
        XCTAssertNil(values, "Should have returned nil square index 9")
        
        values = sudoku.valuesInSquare(1)
        XCTAssertEqual(values!.count, 4, "Square should only contain 4 values")
        XCTAssertTrue(contains(values!, 9), "Square should contain 9")
        XCTAssertTrue(contains(values!, 4), "Square should contain 4")
        XCTAssertTrue(contains(values!, 6), "Square should contain 6")
        XCTAssertTrue(contains(values!, 8), "Square should contain 8")
    }
    
    func testValidNumbersInCoord(){
        var sudokuString = "7...9...32..468..1..8...6...4..2..9....3.4....8..1..3...9...7..5..142..68...5...2"
        var sudoku = Sudoku(string: sudokuString)!
        
        var values = sudoku.validValuesForCoord(x: 0, y: 9)
        XCTAssertNil(values, "Should have returned nil for incorrect coord")
        
        values = sudoku.validValuesForCoord(x: 1, y: 0)
        XCTAssertEqual(values!.count, 3, "coord should only have 3 valid values")
        XCTAssertTrue(contains(values!, 5), "Valid values should contain 5")
        XCTAssertTrue(contains(values!, 6), "Valid values should contain 6")
        XCTAssertTrue(contains(values!, 1), "Valid values should contain 1")
    }
    
    
    
}
