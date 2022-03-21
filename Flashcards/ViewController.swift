//
//  ViewController.swift
//  Flashcards
//
//  Created by h42codes on 3/4/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}


class ViewController: UIViewController {
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    // Array to hold flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // outer container (card) with rounded corners and shadow
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.3
        
        // front/back labels with rounded corners
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        // buttons with rounded corners and border
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0, green: 0.4596315026, blue: 0.8920277953, alpha: 1)
        
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0, green: 0.4596315026, blue: 0.8920277953, alpha: 1)
        
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0, green: 0.4596315026, blue: 0.8920277953, alpha: 1)
        
        // Read saved flashcards
        readSavedFlashcards()
        
        // Adding our initial flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of South Korea?", answer: "Seoul", extraAnswerOne: "New York", extraAnswerTwo: "Paris", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
            // updateDeleteButton()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // destination of the segue is the navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        // Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // set the flashcardsController property to self
        creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
            // creationController.initialExtraAnswerOne = btnOptionOne.title(for: .normal)
            creationController.initialExtraAnswerOne = btnOptionOne.titleLabel?.text
            creationController.initialExtraAnswerTwo = btnOptionThree.titleLabel?.text
        }
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        // frontLabel.isHidden.toggle()
        if frontLabel.isHidden {
            frontLabel.isHidden = false
        } else {
            frontLabel.isHidden = true
        }
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
        if isExisting {
            // Replace existing flashcard
            flashcards[currentIndex] = flashcard
        } else {
            // Add flashcard to the array
            flashcards.append(flashcard)
            
            // Logging to the console
            print("Added new flashcard")
            print("We now have \(flashcards.count) flashcards")
            
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
        }

        // update buttons
        updateNextPrevButtons()
        
        // update labels
        updateLabels()
        
        // update delete button
        // updateDeleteButton()
        
        // save flashcards every time our flashcards array changes
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        // disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        // get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        btnOptionOne.setTitle(currentFlashcard.extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(currentFlashcard.answer, for: .normal)
        btnOptionThree.setTitle(currentFlashcard.extraAnswerTwo, for: .normal)
        
        // reset options
        btnOptionOne.isHidden = false
        frontLabel.isHidden = false
        btnOptionThree.isHidden = false
    }
    
//    func updateDeleteButton() {
//        // disable delete button if there's only one card
//        if flashcards.count == 1 {
//            deleteButton.isEnabled = false
//        } else {
//            deleteButton.isEnabled = true
//        }
//    }
    
    func saveAllFlashcardsToDisk() {
        // Save array on disk using UserDefaults
        // UserDefaults doesn't know how to store an array of Flashcard on disk
        // It does not how to store an array of dictionaries
        // UserDefaults.standard.set(flashcards, forKey: "flashcards")
        
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
        }
        
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
    }
    
    func readSavedFlashcards() {
        // Read dictionary array from disk (if any)
        // let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards")
        // First time we launch the app, we might not have anything stored
        // We need to check if there's anything stored using `if let`
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            // Here we know for sure we DO have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"]!, extraAnswerTwo: dictionary["extraAnswerTwo"]!)
            }
            
            // Put all saved cards into the flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex -= 1
        updateLabels()
        updateNextPrevButtons()
        // updateDeleteButton()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex += 1
        updateLabels()
        updateNextPrevButtons()
        // updateDeleteButton()
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        // Special case: check if the only card is being deleted
        if flashcards.count == 1 {
            let alert = UIAlertController(title: "Error", message: "You can't delete your only card", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            // present the alert controller!
            present(alert, animated: true)
            
        } else {
            // Show confirmation
            let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.deleteCurrentFlashcard()
            }
            alert.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            // present the alert controller!
            present(alert, animated: true)
        }
        
//        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
//
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
//            self.deleteCurrentFlashcard()
//        }
//        alert.addAction(deleteAction)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(cancelAction)
//
//        // present the alert controller!
//        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard() {
        // Delete current card
        flashcards.remove(at: currentIndex)
        
        // Speical case: check if the last card was deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        updateNextPrevButtons()
        updateLabels()
        // updateDeleteButton()
        // store the updated flashcards array to the disk
        saveAllFlashcardsToDisk()
    }
    
}
