//
//  ViewController.swift
//  MasterMind
//
//  Created by Jonathon Day on 1/19/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var winLabel: UILabel!
   
    @IBOutlet var okButton: UIButton!
    @IBOutlet var hintView: UIStackView!
    
    @IBOutlet var okYConstraint: NSLayoutConstraint!
    
    var activeCodeView: UIView! {
        didSet {
            for view in activeCodeView.subviews {
                let button = view as! UIButton
                button.isEnabled = true
            }
            
            pickerOptions = CodePeg.allColors.map {
                let label = UILabel()
                label.text = "O"
                label.font = UIFont.boldSystemFont(ofSize: 16.0)
                label.textColor = $0
                return label
            }
            
            pickerView.reloadAllComponents()
        }
    }
    
    @IBAction func tappedOK(_ sender: UIButton) {
        //need to guard that all buttons have been selected here
        let codeViewButtons = activeCodeView.subviews
        let pegs = codeViewButtons.flatMap { (view) -> CodePeg? in
            let button = view as! UIButton
            let color = button.titleColor(for: .normal)!
            if color == UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1) {
                return nil
            }
            return CodePeg(color: color)
        }
        
        if pegs.count != codeViewButtons.count {
            let ac = UIAlertController(title: "Code Incomplete", message: "Please ensure you've selected at least four colors.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
            ac.addAction(dismissAction)
            self.present(ac, animated: true)
            return
        } else {
            
            let code = Code(pegs: pegs)
            board!.addCode(code)
            
            for view in codeViewButtons {
                let button = view as! UIButton
                button.isEnabled = false
            }
            
            let currentIndex = boardView.subviews.index(of: activeCodeView)!
            let hint = board!.hints.last!
            
            if hint.pegs == Array(repeating: KeyPeg.black, count: 4) {
                userWon()
            }
            
            let hintSubViews = hint.pegs.map { (peg) -> UIButton in
                let button = UIButton()
                
                switch peg {
                case .black:
                    button.setTitle("⚫️", for: .normal)
                case .white:
                    button.setTitle("⚪️", for: .normal)
                }
                
                return button
            }
            
            for i in hintSubViews {
                let currentHint = hintView.subviews[currentIndex] as! UIStackView
                currentHint.addArrangedSubview(i)
            }
            
            
            if currentIndex == boardView.subviews.startIndex {
                winLabel.text = "You Lost :-("
                winLabel.isHidden = false
                okButton.isEnabled = false
            } else {
                let newIndex = boardView.subviews.index(before: currentIndex)
                activeCodeView = boardView.subviews[newIndex]
                okYConstraint.constant -= boardView.spacing * 4
                view.layoutIfNeeded()
            }
            
        }
        
    }
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var boardView: UIStackView!
    
    var board = Board(codes: nil, key: nil)
    
    var pickerOptions: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allSlots = boardView.subviews.map({$0.subviews})
        let allButtons = allSlots.flatMap({$0}) as! [UIButton]
        
        for button in allButtons {
            button.addTarget(self, action: #selector(pegButtonTapped(_:)), for: .touchUpInside)
            button.adjustsImageWhenDisabled = true
            button.isEnabled = false
        }
        
        winLabel.isHidden = true
        
        activeCodeView = boardView.subviews.last!

}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userWon() {
        winLabel.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return pickerOptions[row]
    }
    
    //trying to fix bug where picker view does not show the currently selected item
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pegButtonTapped(_ sender: UIButton) {
        let color = sender.currentTitleColor as UIColor
        let defaultColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        
        if color != defaultColor {
            let label = UILabel()
            label.text = "O"
            label.font = UIFont.boldSystemFont(ofSize: 16.0)
            label.textColor = color
            pickerOptions.append(label)
            pickerView.reloadAllComponents()
        }
        
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if pickerOptions.count != 0 {
        let selectedColor = pickerOptions[selectedRow].backgroundColor!
        pickerOptions.remove(at: selectedRow)
        pickerView.reloadAllComponents()
        sender.setTitleColor(selectedColor, for: .normal)
        }
    }
    
}

