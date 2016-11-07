//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var hangmanPic: UIImageView!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    var phrase: String = "";
    var countWrong = 1;
    var countRight = 0;
    var countBlanks = 0;
    
    var blanks:NSMutableArray = NSMutableArray()
    var incorrectGuesses:NSMutableArray = NSMutableArray()
    var correct:Bool = false;
    
    func resetParams(){
        hangmanPic.image = UIImage(named: "hangman1.gif")
        phrase = "";
        countWrong = 1;
        countRight = 0;
        countBlanks = 0;
        blanks = NSMutableArray()
        incorrectGuesses = NSMutableArray()
        incorrectGuessesLabel.text = ""
        correct = false;
        self.viewDidLoad()
        
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        for i in 0...(phrase.characters.count) - 1{
            if(String(phrase[phrase.index(phrase.startIndex, offsetBy: i)]) == " "){
                blanks.add(" ")
                countBlanks = countBlanks + 1
            }
            else{
                blanks.add("_ ")
            }
            
        }
        wordLabel.text = blanks.componentsJoined(by: "")
    }
    
    @IBAction func guessButton(_ sender: AnyObject) {
        if((textField) != nil){
            let guess = textField.text
            //if letter is in the phrase - update blank, go through blank wordLabel
            print(phrase.characters.count)
            for i in 0...(phrase.characters.count - 1){
                if(guess == String(phrase[phrase.index(phrase.startIndex, offsetBy: i)])){
                    blanks[i] = guess!
                    correct = true
                    countRight = countRight + 1
                }
                
            }
            if (correct == false){
                incorrectGuesses.add(guess!)
                incorrectGuessesLabel.text = incorrectGuesses.componentsJoined(by: " ")
                countWrong = countWrong + 1
                if(countWrong < 8){
                    hangmanPic.image = UIImage(named: "hangman" + String(countWrong) + ".gif")
                }
                //else popup - you failed
                if(countWrong == 7){
                    // create the alert
                    let alert = UIAlertController(title: "You Lose", message: "Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.default, handler: nil))
                    self.resetParams()
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
            //if won game
            if (phrase == blanks.componentsJoined(by: "") && countWrong<8){
                let alert = UIAlertController(title: "You Win!", message: "Play again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.default, handler: nil))
                self.resetParams()
                self.present(alert, animated: true, completion: nil)
            }
            correct = false
            wordLabel.text = blanks.componentsJoined(by: " ")
            //if letter not in phrase - update incorrectGessesLabel
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
