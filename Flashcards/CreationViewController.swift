//
//  CreationViewController.swift
//  Flashcards
//
//  Created by h42codes on 3/12/22.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    var initialQuestion: String?  // it's okay for initial values to be nil
    var initialAnswer: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        // grab the text in the question and answer text fields
        // and call the function in flashards view controller
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        if questionText == "" || answerText == "" {
            // error message
            let alert = UIAlertController(title: "Missing text", message: "You need to enter both a question and an answer", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        } else {
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!)
            dismiss(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
