//
//  SwipeVc.swift
//
//  Created by Charan on 24/10/18.
//  Copyright © 2018 Charan. All rights reserved.
//

import UIKit

let  KmaxBufferSize = 3
let  KseperatorDistance = 8
let  Ktopyaxis = 75

class Model{
    var fullName = "Charan"
    var firstLeter = "C"
    var number = "+919814577779"
}

class SwipeVc: UIViewController,UIGestureRecognizerDelegate {
    
    //MARK::- OUTLETS
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vwFrame: UIView!
    @IBOutlet weak var viewTinderBackGround: UIView!
    
    //MARK::- VERIABLES
    var arrPointsForVw1 : [CGPoint] = []
    var arrPointsForVw2 : [CGPoint] = []
    var arrPointsForVw3 : [CGPoint] = []
    var arrPointsForVw4 : [CGPoint] = []
    
    let maxValueForY = CGFloat(1.5)
    let minValueForY = CGFloat(0.5)
    
    var currentIndex = 0
    
    lazy var currentLoadedCardsArray = [Card]()
    lazy var allCardsArray = [Card]()
    
    var arrPhoneContacts : [Model] = [Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model(),Model()]
    
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setFrames()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
    }
    
    
    //MARK::- FUNCTIONS
    
    func setFrames(){
        DispatchQueue.main.async {
            self.setCornerRadius(views: [self.vw1,self.vw2,self.vw3,self.vw4])
            self.calculatePointsForVw1()
        }
    }

    func setCornerRadius(views:[UIView]){
        views.forEach { $0.layer.cornerRadius = ($0.bounds.size.width/2)+($0.bounds.size.width/15)}
    }
        
    func loadCardValues() {
        if arrPhoneContacts.count > 0 {
            
            let capCount = (arrPhoneContacts.count > KmaxBufferSize) ? KmaxBufferSize : arrPhoneContacts.count
            
            for (i,_) in arrPhoneContacts.enumerated() {
                let newCard = createCard(arrPhoneContacts[i])
                allCardsArray.append(newCard)
                if i < capCount {
                    currentLoadedCardsArray.append(newCard)
                }
            }
            
            for (i,_) in currentLoadedCardsArray.enumerated() {
                if i > 0 {
                    viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                }else {
                    viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
                }
            }
            animateCardAfterSwiping()
        }
    }
    
    func createCard(_ obj:Model) -> Card {
        
        let card = Card(frame: vwFrame.frame, obj:obj)
        
        card.delegate = self
        card.vwReact1 = vw1
        card.vwReact2 = vw2
        card.vwReact3 = vw3
        card.vwReact4 = vw4
        card.arrPointsForVw1 = arrPointsForVw1
        card.arrPointsForVw2 = arrPointsForVw2
        card.arrPointsForVw3 = arrPointsForVw3
        card.arrPointsForVw4 = arrPointsForVw4
        return card
    }
    
    func calculatePointsForVw1(){
        var y = vw1.bounds.size.height/2
        var x = vw1.bounds.size.height/2
        for i in 0...Int(x){
            if CGFloat(i) > (x/2){
                y = y - maxValueForY
            }else{
                y = y - minValueForY
            }
            arrPointsForVw1.append(CGPoint(x: CGFloat(i), y: y))
        }
        y = vw1.bounds.size.height/2
        x = UIScreen.main.bounds.size.width - (vw2.bounds.size.height/2)
        var y1 = CGFloat(0)
        for i in 0...Int(y){
            if CGFloat(i) < (y/2){
                y1 = y1 + maxValueForY
            }else{
                y1 = y1 + minValueForY
            }
            arrPointsForVw2.append(CGPoint(x: x+CGFloat(i), y: y1))
        }
        y1 = vw3.frame.origin.y
        x = vw1.bounds.size.height/2
        for i in 0...Int(x){
            if CGFloat(i) > (x/2){
                y1 = y1 + maxValueForY
            }else{
                y1 = y1 + minValueForY
            }
            arrPointsForVw3.append(CGPoint(x: CGFloat(i), y: y1))
        }
        x = UIScreen.main.bounds.size.width - (vw2.bounds.size.height/2)
        y1 = UIScreen.main.bounds.size.height
        for i in 0...Int(y){
            if CGFloat(i) < (y/2){
                y1 = y1 - maxValueForY
            }else{
                y1 = y1 - minValueForY
            }
            arrPointsForVw4.append(CGPoint(x: x+CGFloat(i), y: y1))
        }
        loadCardValues()
    }
    
    func removeObjectAndAddNewValues() {
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(KmaxBufferSize * KseperatorDistance) + vwFrame.frame.origin.y
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[KmaxBufferSize - 1], belowSubview: currentLoadedCardsArray[KmaxBufferSize - 2])
        }
        animateCardAfterSwiping()
    }
    
    func animateCardAfterSwiping() {
        
        for (i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                card.isUserInteractionEnabled = i == 0
                var frame = card.frame
                frame.origin.y = CGFloat(i * KseperatorDistance) + self.vwFrame.frame.origin.y
                card.frame = frame
            })
        }
    }
    
    
    //MARK::- IBACTIONS
    
    
}

//MARK::-
extension SwipeVc : CardDelegate{
    
    // action called when the card goes.
    func cardGoes(card: Card,obj:Model) {
        removeObjectAndAddNewValues()
        if card.dropCardNo < 5{
            print(card.dropCardNo)
        }else{
            print("Skiped")
        }
    }
}
