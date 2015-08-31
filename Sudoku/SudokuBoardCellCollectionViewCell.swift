//
//  SudokuBoardCellCollectionViewCell.swift
//  Sudoku
//
//  Created by Olof Moriya on 29/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

class SudokuBoardCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!

    @IBOutlet weak var availableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
