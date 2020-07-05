//
//  ViewController.swift
//  Project_2
//
//  Created by Vinicius Emanuel on 23/06/20.
//  Copyright © 2020 Vinicius Emanuel. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var guess: NSTextField!
    
    var guesses: [String] = []
    var answer: String = "1234"
    
    var numbers = Array(0...9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startNewGame()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }

    @IBAction func submitGuess(_ sender: Any) {
        let guessString = guess.stringValue
        guard Set(guessString).count == 4 else {
            let alert = NSAlert()
            alert.informativeText = "Need to be iqual to 4 diferents characteres"
            alert.runModal()
            
            return
        }
        
        let badCharacteres = CharacterSet(charactersIn: "0123456789").inverted
        guard guessString.rangeOfCharacter(from: badCharacteres) == nil else { return }
        
        guesses.insert(guessString, at: 0)
        tableView.insertRows(at: IndexSet(integer: 0), withAnimation: .slideDown)
        
        let resultString = self.result(for: guessString)
        if resultString.contains("4b"){
            let alert = NSAlert()
            alert.messageText = "you win"
            alert.informativeText = "Congratulations! Click Ok to play again."
            alert.runModal()
            
            self.startNewGame()
        }
    }
    
    func result(for guess: String) -> String{
        var bulls = 0
        var cows = 0
        
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (index, letter) in guessLetters.enumerated(){
            if letter == answerLetters[index]{
                bulls += 1
            }else if answerLetters.contains(letter){
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }
    
    func startNewGame(){
        guess.stringValue = ""
        guesses.removeAll()
        numbers.shuffle()
        answer = ""
        
        for index in 0...3{
            answer.append("\(numbers[index])")
        }
        
        tableView.reloadData()
    }
    
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.guesses.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let view = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }

        if tableColumn?.title == "Guess"{
            view.textField?.stringValue = self.guesses[row]
        }else{
            view.textField?.stringValue = self.result(for: self.guesses[row])
        }

        return view
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
}

