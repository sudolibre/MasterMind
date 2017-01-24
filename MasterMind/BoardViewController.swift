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
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        if let pegView = view.subviews.first(where: {$0 is UIImageView && $0.frame.contains(tapLocation)}) {
            print("peg color selected")
            if pegView.alpha > 0.5 {
                currentlySelectedColor = pegView.tintColor
            }
        }
        
    }
    var currentlySelectedColor: UIColor?
    
    var pegSelectionViews: [UIImageView] {
        return view.subviews.flatMap({$0 as? UIImageView})
    }
    
    var activeCodeView: UIView! {
        didSet {
            for view in activeCodeView.subviews {
                let button = view as! UIButton
                button.isEnabled = true
            }
                        
            for view in pegSelectionViews {
                addPegViewToSelection(view)
            }
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
    
    var pickerOptions: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(view.frame)
        print(view.bounds)
        let allSlots = boardView.subviews.map({$0.subviews})
        let allButtons = allSlots.flatMap({$0}) as! [UIButton]
        
        for button in allButtons {
            button.addTarget(self, action: #selector(pegSlotTapped(_:)), for: .touchUpInside)
            button.adjustsImageWhenDisabled = true
            button.isEnabled = false
        }
        
        let colors = CodePeg.allColors
        
        for pair in zip(pegSelectionViews, colors) {
            pair.0.tintColor = pair.1
            pair.0.image = UIImage(named: "ball")!.withRenderingMode(.alwaysTemplate)
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
    
    func createBallFromColor(_ color: UIColor) -> UIImageView {
        let image = UIImage(named: "ball")!.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func pegViewForButton(_ button: UIButton) -> UIImageView? {
        return button.superview!.subviews.first(where: { $0.center == button.center && $0 is UIImageView }) as? UIImageView
    }
    
    func removePegViewFromSelection(_ pegView: UIImageView) {
        pegView.alpha = 0.5
    }
    func addPegViewToSelection(_ pegView: UIImageView) {
        pegView.alpha = 1
    }
    
    func pegSlotTapped(_ sender: UIButton) {
        let parentStackView = sender.superview!
        
        //add peg for currently selected color
        guard currentlySelectedColor != nil else { return }
        
        //add previous color back to selection
        let previousPegView = pegViewForButton(sender)
        if let pegViewSelectionToRestore = view.subviews.first(where: {$0 is UIImageView && $0.tintColor == previousPegView?.tintColor }) as? UIImageView {
            addPegViewToSelection(pegViewSelectionToRestore)
        }
        previousPegView?.removeFromSuperview()
        
        let ballWithColor = createBallFromColor(currentlySelectedColor!)
        ballWithColor.center = sender.center
        parentStackView.addSubview(ballWithColor)
        if let pegViewSelection = view.subviews.first(where: {$0 is UIImageView && $0.tintColor == currentlySelectedColor }) as? UIImageView {
            removePegViewFromSelection(pegViewSelection)
            currentlySelectedColor = nil
        }
    }
    
}
