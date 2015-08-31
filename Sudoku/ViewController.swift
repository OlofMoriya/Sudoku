//
//  ViewController.swift
//  Sudoku
//
//  Created by Olof Moriya on 28/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, FileLoaderDelegate {


    @IBOutlet weak var collectionView: UICollectionView!
    var sudoku: Sudoku?{
        didSet{
            originalSudoku = Sudoku.copy(sudoku!)
        }
    }
    var originalSudoku: Sudoku?
    var showInfo = false
    var solving = false
    let SudokuBoardCellIdentifier = "SudokuBoardCellCollectionViewCell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var subsetButton: UIButton!
    @IBOutlet weak var uniqueButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var soleButton: UIButton!
    @IBOutlet weak var backtrackButton: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!

    //MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var startSudokuString = "7...9...32..468..1..8...6...4..2..9....3.4....8..1..3...9...7..5..142..68...5...2"
        
        sudoku = Sudoku(string: startSudokuString)!
        
        activityIndicator.layer.cornerRadius = 5
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        var size = (UIScreen.mainScreen().bounds.size.width - 32) / 9
        flowLayout.itemSize = CGSize(width: size, height: size)
        self.collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
        collectionView.registerNib(UINib(nibName: SudokuBoardCellIdentifier, bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: SudokuBoardCellIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView.reloadData()
    }
    
    func isSingleSolution(solvedSudoku:Sudoku, originalSudoku:Sudoku)->Bool{
        
        var solver = SudokuSolver()
        solver.backtrack(originalSudoku, ignoreSolutions: [solvedSudoku])
        if originalSudoku.sum() == 405{
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let fileLoaderViewController = segue.destinationViewController as? FileLoaderViewController{
            fileLoaderViewController.delegate = self
        }
    }
    
    //MARK: Actions
    
    @IBAction func backtrackTapped(sender: AnyObject) {
        if let sudoku = sudoku{
            var solver = SudokuSolver()
            solver.backtrack(sudoku, ignoreSolutions: [])
            collectionView.reloadData()
        }
    }
    
    @IBAction func numberDidChange(sender: AnyObject) {
        if let indexPath = selectedIndexPath, value = numberTextField.text.toInt(){
            sudoku!.data[indexPath.row] = value
            collectionView.reloadItemsAtIndexPaths([indexPath])
            if sudoku!.validate(){
                var alertView = UIAlertView(title: "Congratulations", message: "You completed the sudoku successfully", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            }
        }
        numberTextField.resignFirstResponder()
    }
    
    @IBAction func subsetTapped(sender: AnyObject) {
        if let sudoku = sudoku{
            var solver = SudokuSolver()
            solver.nakedSubset(sudoku)
            sudoku.data = Utils.transposeMatrix(sudoku.data)
            solver.nakedSubset(sudoku)
            sudoku.data = Utils.transposeMatrix(sudoku.data)
            
            collectionView.reloadData()
        }
    }
    
    @IBAction func uniqueTapped(sender: AnyObject) {
        if let sudoku = sudoku{
            var solver = SudokuSolver()
            solver.uniquePerRow(sudoku)
            sudoku.data = Utils.transposeMatrix(sudoku.data)
            solver.uniquePerRow(sudoku)
            sudoku.data = Utils.transposeMatrix(sudoku.data)
            
            collectionView.reloadData()
        }
    }
    
    @IBAction func soleTapped(sender: AnyObject) {
        if let sudoku = sudoku{
            var solver = SudokuSolver()
            solver.soleCandidate(sudoku)
            collectionView.reloadData()
        }
    }
    
    @IBAction func crossTapped(sender: AnyObject) {
        if let sudoku = sudoku{
            var solver = SudokuSolver()
            solver.dubbleRowDubbleColumn(sudoku)
            collectionView.reloadData()
        }
    }

    @IBAction func solveTapped(sender: AnyObject) {
        if sudoku == nil || solving{
            return
        }
        
        solving = true
        activityIndicator.startAnimating()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let original = Sudoku.copy(self.sudoku!)
            
            var status = ""
            
            var solver = SudokuSolver()
            solver.soleCandidate(self.sudoku!)
            var sum = self.sudoku!.sum()
            if sum == 405 && self.isSingleSolution(self.sudoku!, originalSudoku: original){
                status = "Simple"
            }
            
            if sum != 405{
                solver.solve(self.sudoku!)
                if self.sudoku!.sum() == 405 && self.isSingleSolution(self.sudoku!, originalSudoku: original){
                    status = "Medium"
                }
                sum = self.sudoku!.sum()
            }
            if sum != 405{
                solver.backtrack(self.sudoku!, ignoreSolutions: [])
                if self.sudoku!.sum() == 405 && self.isSingleSolution(self.sudoku!, originalSudoku: original){
                    status = "Hard"
                }else if self.sudoku!.sum() == 405{
                    status = "Not a single sulotion"
                } else {
                    status = "Could not solve"
                }
                sum = self.sudoku!.sum()
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.statusLabel.text = status
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            self.solving = false
        }
    }

    @IBAction func infoButtonTapped(sender: AnyObject) {
        showInfo = !showInfo
        uniqueButton.hidden = !showInfo
        soleButton.hidden = !showInfo
        crossButton.hidden = !showInfo
        subsetButton.hidden = !showInfo
        backtrackButton.hidden = !showInfo
        iconImageView.hidden = showInfo
        
        collectionView.reloadData()
    }
    
    //MARK: CollectionView

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return sudoku != nil ? 81 : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(SudokuBoardCellIdentifier, forIndexPath: indexPath) as! SudokuBoardCellCollectionViewCell
        if sudoku!.data[indexPath.row] == 0{
            cell.numberLabel.text = ""
        }else{
            cell.numberLabel.text = "\(sudoku!.data[indexPath.row])"
        }
        
        let coord = Sudoku.coordFromIndex(indexPath.row)

        if showInfo{
            cell.numberLabel.textColor = originalSudoku!.data[indexPath.row] != 0 ? Colors.mainColor : Colors.gray
            cell.availableLabel.text = sudoku!.validValuesForCoord(x: coord.x, y: coord.y)!.count == 0 ? "" : "\(sudoku!.validValuesForCoord(x: coord.x, y: coord.y)!)"
        }else{
            cell.availableLabel.text = ""
            cell.numberLabel.textColor = Colors.gray
        }
        
        return cell
    }
    
    var selectedIndexPath: NSIndexPath?
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        numberTextField.becomeFirstResponder()
    }
    
    //MARK: FileLoaderDelegate
    
    func selectedFile(name: String) {
        var path = NSBundle.mainBundle().pathForResource(name, ofType: "sudoku")
        var text = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)!
        var hardSudokuString = text.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
        if let sudoku = Sudoku(string: hardSudokuString){
            self.sudoku = sudoku
            originalSudoku  = Sudoku(string: hardSudokuString)!
            collectionView.reloadData()
            statusLabel.text = ""
        }else{
            sudoku = nil
            originalSudoku = nil
            collectionView.reloadData()
            statusLabel.text = "Sudoku file does not have the correct format!"
        }
    }
    
    func createdSudoku(sudoku: Sudoku) {
        self.sudoku = sudoku
        collectionView.reloadData()
    }
}

