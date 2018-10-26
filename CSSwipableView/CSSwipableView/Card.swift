//
//  Card.swift
//
//  Created by Charan on 24/10/18.
//  Copyright © 2018 Charan. All rights reserved.
//

import UIKit

let  KscreenWidthHalf = UIScreen.main.bounds.size.width/2
let  KscreenWidth = UIScreen.main.bounds.size.width
let  KscreenHeight = UIScreen.main.bounds.size.height
let  KscaleStrength : CGFloat = 4
let  KscaleRange : CGFloat = 0.90

//MARK::-Protocol
protocol CardDelegate: NSObjectProtocol {
    func cardGoes(card: Card,obj:Model)
}

class Card: UIView {
    
    //MARK::- VERIABLES
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    var dropCardNo = -1
    weak var vwReact1 : UIView?
    weak var vwReact2 : UIView?
    weak var vwReact3 : UIView?
    weak var vwReact4 : UIView?
    
    var arrPointsForVw1 : [CGPoint] = []
    var arrPointsForVw2 : [CGPoint] = []
    var arrPointsForVw3 : [CGPoint] = []
    var arrPointsForVw4 : [CGPoint] = []
    weak var delegate: CardDelegate?
    var objModel : Model?
    
    //MARK::- Life cycle methods
    public init(frame: CGRect,obj:Model) {
        super.init(frame: frame)
        setupView(obj)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK::- FUNCTIONS
    private func setupView(_ obj:Model) {
        objModel = obj
        layer.cornerRadius = 5
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        
        layer.shadowColor = UIColor.darkGray.cgColor
        clipsToBounds = false
        isUserInteractionEnabled = false
        
        originalPoint = center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
        
        let btnSkip = UIButton(frame: CGRect(x: frame.size.width-60, y: 0, width: 60, height: 60))
        btnSkip.setTitleColor(.blue, for: .normal)
        btnSkip.setTitle("Skip", for: .normal)
        btnSkip.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnSkip.addTarget(self, action: #selector(skip), for: .touchUpInside)
        addSubview(btnSkip)
        
        let lblNameFirstLeter = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lblNameFirstLeter.textColor = UIColor.white
        lblNameFirstLeter.textAlignment = .center
        lblNameFirstLeter.clipsToBounds = true
        lblNameFirstLeter.layer.cornerRadius = 20
        lblNameFirstLeter.backgroundColor = .black
        lblNameFirstLeter.font = UIFont.systemFont(ofSize: 14)
        lblNameFirstLeter.text = obj.firstLeter
        addSubview(lblNameFirstLeter)
        lblNameFirstLeter.center = CGPoint(x: frame.size.width/2, y: (frame.size.height/2)-(lblNameFirstLeter.frame.size.height/1.5))
        
        let lblName = UILabel(frame: CGRect(x: 0, y: lblNameFirstLeter.frame.origin.y+50, width: frame.size.width, height: 25))
        lblName.textColor = UIColor.darkGray
        lblName.textAlignment = .center
        lblName.font = UIFont.systemFont(ofSize: 16)
        lblName.text = obj.fullName
        addSubview(lblName)
        
        let lblNo = UILabel(frame: CGRect(x: 0, y: lblName.frame.origin.y+20, width: frame.size.width, height: 25))
        lblNo.textColor = UIColor.darkGray
        lblNo.textAlignment = .center
        lblNo.font = UIFont.systemFont(ofSize: 12)
        lblNo.text = obj.number
        addSubview(lblNo)
        
    }
    
    @objc func skip(_ sender:UIButton){
        dropCardNo = 5
        removeCard()
    }
    
    @objc private func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = self.center;
            break
        //in the middle of a swipe
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/20 * rotationStrength
            let scale = max(1 - fabs(rotationStrength) / KscaleStrength, KscaleRange)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            allWight()
            if center.x > KscreenWidthHalf{
                if (vwReact2?.frame.intersects(frame)) ?? false{
                    compare2()
                }else if (vwReact4?.frame.intersects(frame)) ?? false{
                    compare4()
                }
            }else{
                if (vwReact1?.frame.intersects(frame)) ?? false{
                    compare1()
                }else if (vwReact3?.frame.intersects(frame)) ?? false{
                    compare3()
                }
            }
            
            break;
            
        // swipe ended
        case .ended:
            afterSwipeAction()
            break;
            
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
    }
    
    @discardableResult
    private func compare1()->Bool{
        return commonCompare(arr: arrPointsForVw1, vw: vwReact1)
    }
    
    @discardableResult
    private func compare2()->Bool{
        return commonCompare(arr: arrPointsForVw2, vw: vwReact2)
    }
    
    @discardableResult
    private func compare3()->Bool{
        return commonCompare(arr: arrPointsForVw3, vw: vwReact3)
    }
    
    @discardableResult
    private func compare4()->Bool{
        return commonCompare(arr: arrPointsForVw4, vw: vwReact4)
    }
    
    private func commonCompare(arr:[CGPoint],vw:UIView?)->Bool{
        for point in arr{
            if(self.frame.contains(point)){
                changeBackgoundGrey(views: [vw])
                return true
            }
        }
        return false
    }
    
    private func allWight(){
        changeBackgoundWight(views: [vwReact1 ,vwReact2 , vwReact3 , vwReact4])
    }
    
    private func changeBackgoundWight(views: [UIView?]){
        views.forEach { $0?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
    }
    
    private func changeBackgoundGrey(views: [UIView?]){
        views.forEach { $0?.backgroundColor = .blue }
    }
    
    private func afterSwipeAction() {
        if center.x > KscreenWidthHalf{
            if (vwReact2?.frame.intersects(frame)) ?? false{
                if compare2(){
                    r2()
                }else{
                    putImageBack()
                }
            }else if (vwReact4?.frame.intersects(frame)) ?? false{
                if compare4(){
                    r4()
                }else{
                    putImageBack()
                }
            }else{
                putImageBack()
            }
        }else{
            if (vwReact1?.frame.intersects(frame)) ?? false{
                if compare1(){
                    r1()
                }else{
                    putImageBack()
                }
            }else if (vwReact3?.frame.intersects(frame)) ?? false{
                if compare3(){
                    r3()
                }else{
                    putImageBack()
                }
            }else{
                putImageBack()
            }
        }
    }
    
    private func putImageBack(){
        UIView.animate(withDuration: 0.2, animations: {
            self.center = self.originalPoint
            self.transform = CGAffineTransform(rotationAngle: 0)
        })
    }
    
    private func removeCard(){
        removeFromSuperview()
        if let obj = objModel{
            delegate?.cardGoes(card: self,obj:obj)
        }
        allWight()
    }
    
    private func r1() {
        UIView.animate(withDuration: 0.2, animations: {
            self.center = CGPoint.zero
        }) { (yes) in
            self.dropCardNo = 1
            self.removeCard()
        }
    }
    
    private func r2() {
        UIView.animate(withDuration: 0.2, animations: {
            self.center = CGPoint(x: KscreenWidth, y: 0)
        }) { (yes) in
            self.dropCardNo = 2
            self.removeCard()
        }
    }
        
    private func r3() {
        UIView.animate(withDuration: 0.2, animations: {
            self.center = CGPoint(x: 0, y: KscreenHeight)
        }) { (yes) in
            self.dropCardNo = 3
            self.removeCard()
        }
    }
        
    private func r4() {
        UIView.animate(withDuration: 0.2, animations: {
            self.center = CGPoint(x: KscreenWidth, y: KscreenHeight)
        }) { (yes) in
            self.dropCardNo = 4
            self.removeCard()
        }
    }
    
    private func shakeAnimationCard(){
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.center = CGPoint(x: self.center.x - (self.frame.size.width / 2), y: self.center.y)
            self.transform = CGAffineTransform(rotationAngle: -0.2)
        }, completion: {(_) -> Void in
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: {(_ complete: Bool) -> Void in
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.center = CGPoint(x: self.center.x + (self.frame.size.width / 2), y: self.center.y)
                    self.transform = CGAffineTransform(rotationAngle: 0.2)
                }, completion: {(_ complete: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.center = self.originalPoint
                        self.transform = CGAffineTransform(rotationAngle: 0)
                    })
                })
            })
        })
    }
}


