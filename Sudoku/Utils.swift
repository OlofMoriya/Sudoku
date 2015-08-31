//
//  Utils.swift
//  Sudoku
//
//  Created by Olof Olsson on 28/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

//http://stackoverflow.com/questions/27624331/unique-values-of-array-in-swift
func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
    var seen: [E:Bool] = [:]
    return filter(source) { seen.updateValue(true, forKey: $0) == nil }
}

//http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let c = count(list)
    if c < 2 { return list }
    for i in 0..<(c - 1) {
        let j = Int(arc4random_uniform(UInt32(c - i))) + i
        swap(&list[i], &list[j])
    }
    return list
}

class Utils{
     static func transposeMatrix(matrix:[Int])->[Int]{
        var transposedMatrix:[Int] = []
        for i in 0...8{
            for j in 0...8{
                transposedMatrix.append(matrix[j * 9 + i])
            }
        }
        return transposedMatrix
    }
    
    static func arraysAreEqual(#a:[Int], b:[Int])->Bool{
        if a.count != b.count{
            return false
        }
        
        for value in a{
            if !contains(b,value){
                return false
            }
        }
        for value in b{
            if !contains(a,value){
                return false
            }
        }
    
        return true
    }
}