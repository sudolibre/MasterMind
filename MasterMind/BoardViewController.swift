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
   
    @IBOutlet var ballImage: UIImageView!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var hintView: UIStackView!
    
    @IBOutlet var okYConstraint: NSLayoutConstraint!
    
    let allColorOption = CodePeg.allColors
    var usedColorOptions: Set<UIColor> = []
    var remainingColorOptions: Set<UIColor> {
        let allColorSet = Set(allColorOption)
        let usedColorSet = Set(usedColorOptions)
        return allColorSet.subtracting(usedColorSet)
    }
    
    var pickerOptions: [UIImageView] {
        return remainingColorOptions.map(createBallFromColor)
    }
    
    var activeCodeView: UIView! {
        didSet {
            for view in activeCodeView.subviews {
                let button = view as! UIButton
                button.isEnabled = true
            }
            
            usedColorOptions.removeAll()
            pickerView.reloadAllComponents()
        }
    }
    
    @IBAction func tappedOK(_ sender: UIButton) {
        let codeViewImages = activeCodeView.subviews
        // create pegs from each color
        let pegs = codeViewImages.flatMap { (view) -> CodePeg? in
            let imageView = view as? UIImageView
            if let color = imageView?.tintColor! {
            return CodePeg(color: color)
            } else {
                return nil
            }
        }
        
        // ensure we have enough pegs then add them to the datasource
        if pegs.count < 4 {
            let ac = UIAlertController(title: "Code Incomplete", message: "Please ensure you've selected at least four colors.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
            ac.addAction(dismissAction)
            self.present(ac, animated: true)
            return
        } else {
            
            let code = Code(pegs: pegs)
            board!.addCode(code)
            
            for case let button as UIButton in codeViewImages {
                button.isEnabled = false
            }

            
            let currentIndex = boardView.subviews.index(of: activeCodeView)!
            let hint = board!.hints.last!
            
            if hint.pegs == Array(repeating: KeyPeg.black, count: 4) {
                userWon()
            }
            
            let hintSubViews = hint.pegs.map { (peg) -> UIImageView in
                return createBallFromColor(peg.color)
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
    
    func createBallFromColor(_ color: UIColor) -> UIImageView {
        let image = UIImage(named: "ball")!.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func pegButtonTapped(_ sender: UIButton) {
        let parentStackView = sender.superview!
        let color = sender.currentTitleColor as UIColor
        let defaultColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        
        
        
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if pickerOptions.count != 0 {
            let selectedColor = pickerOptions[selectedRow].tintColor!
            usedColorOptions.insert(selectedColor)
            let ballWithColor = createBallFromColor(selectedColor)
            ballWithColor.center = sender.center
            parentStackView.addSubview(ballWithColor)
            sender.setTitleColor(selectedColor, for: .normal)
        }
        
        // if the current color of the button is not the default color add that color back to the options
        if color != defaultColor {
            usedColorOptions.remove(color)
            let previousImage = parentStackView.subviews.first(where: {$0.center == sender.center && $0 is UIImageView})
            previousImage?.removeFromSuperview()
        }
        
        pickerView.reloadAllComponents()

    }
    
}

