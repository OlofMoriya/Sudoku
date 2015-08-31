//
//  FileLoaderViewController.swift
//  Sudoku
//
//  Created by Olof Olsson on 29/08/15.
//  Copyright (c) 2015 Olof Moriya. All rights reserved.
//

import UIKit

protocol FileLoaderDelegate: class{
    func selectedFile(name:String)
    func createdSudoku(sudoku:Sudoku)
}

class FileLoaderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var fileList:[String]=[]
    weak var delegate: FileLoaderDelegate?
    
    @IBAction func createSudokutapped(sender: AnyObject) {
        var createAlert = UIAlertController(title: "Create", message: "Choose difficulty", preferredStyle: UIAlertControllerStyle.ActionSheet)

        createAlert.addAction(UIAlertAction(title: "Easy", style: .Default, handler: { (action: UIAlertAction!) in
            var generator = SudokuGenerator()
            
            self.activityIndicator.startAnimating()
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                var sudoku = generator.generateEasySudoku()
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.delegate?.createdSudoku(sudoku)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }))
        
        createAlert.addAction(UIAlertAction(title: "Medium", style: .Default, handler: { (action: UIAlertAction!) in
            var generator = SudokuGenerator()
            
            self.activityIndicator.startAnimating()
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                var sudoku = generator.generateMediumSudoku()
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.delegate?.createdSudoku(sudoku)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }))
        
        createAlert.addAction(UIAlertAction(title: "Hard", style: .Default, handler: { (action: UIAlertAction!) in
            var generator = SudokuGenerator()

            self.activityIndicator.startAnimating()
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                var sudoku = generator.generateHardSudoku()

                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.delegate?.createdSudoku(sudoku)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }))
        
        createAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(createAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileList = []
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.activityIndicator.layer.cornerRadius = 5
        
        let docsPath = NSBundle.mainBundle().resourcePath! + "/";
        let fileManager = NSFileManager.defaultManager()
        
        var error: NSError?
        if let docsArray = fileManager.contentsOfDirectoryAtPath(docsPath, error:&error) as? [String]{
            for doc in docsArray {
                if doc.rangeOfString(".sudoku", options: NSStringCompareOptions.allZeros, range: nil, locale: nil) != nil{
                    var fileName = doc.componentsSeparatedByString(".")[0]
                    fileList.append(fileName)
                }
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = fileList[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.selectedFile(fileList[indexPath.row])
        navigationController?.popViewControllerAnimated(true)
    }
}
