//
//  SlideNumberValue.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 9/2/23.
//

import Foundation

func foo() {
    Slider(.line, minValue: 0, maxValue: 360, defaultValue: 0.0, editing: \.rotation, nodeEditing: Node()) {
        this.x = width/2
        this.y = 200
    }
}

class NumberSlider<T: AnyObject>: NodeView {
    let text: String
    
    let sliderType: SliderType
    let minValue: Double
    var maxValue: Double { didSet { changeMaxValue(maxValue) } }
    let defaultValue: Double
    var keyPath: ReferenceWritableKeyPath<T, Double>
    let nodeEditing: T
    var changeMaxValue: (Double) -> () = {_ in}
    var updateCurrentValue: (Double) -> () = {_ in}
    
    //let getStatus: () -> Double
    //let setStatus: (Double) -> ()
    
    public var node: Node!
    public var body: Node {
        RoundWindow(width: 300, height: (self.sliderType == .line ? 100 : 300)) {
            Padding(30) {
                VStack {
                    this.vstack.spacing = 5
                    Text(self.text)
                    
                    let o = Slider(self.sliderType, minValue: self.minValue, maxValue: self.maxValue, defaultValue: self.defaultValue, editing: self.keyPath, nodeEditing: self.nodeEditing)
                    self.changeMaxValue = {
                        o.maxValue = $0
                        o.dragSliderTo()
                    }
                    self.updateCurrentValue = {
                        o.currentValue = $0
                        o.render()
                    }
                    
//                    {
//                        this.x = width/2
//                        this.y = 200
//                    }
                    
//                    var numberText: Text!
//
//                    func updateValue(_ by: Double, reset: Bool = false) {
//                        if reset { self.number = 0 }
//                        self.number += by
//                        self.setStatus(self.number)
//                        numberText.__text__.text = "\(self.text): " + self.number.tenths
//                    }
//
//                    for i in self.step.reversed() {
//                        Button(width: 50, height: 50) {
//                            Padding(10) {
//                                Text("-")
//                            }
//                            this.whenTapped {
//                                updateValue(-i)
//                            }
//                        }
//                    }
//
//                    numberText = Text(self.text) { [self] in
//                        number = getStatus()
//                        this.text.text = "\(self.text): " + number.tenths
//                    }
//                    for i in self.step {
//                        Button(width: 50, height: 50) {
//                            Padding(10) {
//                                Text("+")
//                            }
//                            this.whenTapped {
//                                updateValue(i)
//                            }
//                        }
//                    }
                }
            }
        }
    }
    
    @discardableResult
    init(line: String, node: T, status: ReferenceWritableKeyPath<T, Double>, min minValue: Double, max maxValue: Double, def: Double) {
    //init(text: String, node: T, status: ReferenceWritableKeyPath<T, Double>, step: [Double], range: ClosedRange<Double>? = nil, mod: Double? = nil) {
        self.text = line
        self.keyPath = status
        self.sliderType = .line
        //self.getStatus = { node[keyPath: status] }
        //self.setStatus = { node[keyPath: status] = $0 }
        self.nodeEditing = node
        self.maxValue = maxValue
        self.minValue = minValue
        self.defaultValue = def
        self.node = body
    }
    @discardableResult
    init(rotation: String, node: T) where T: Node {
    //init(text: String, node: T, status: ReferenceWritableKeyPath<T, Double>, step: [Double], range: ClosedRange<Double>? = nil, mod: Double? = nil) {
        self.text = rotation
        self.keyPath = \.rotation
        self.sliderType = .circle
        //self.getStatus = { node[keyPath: status] }
        //self.setStatus = { node[keyPath: status] = $0 }
        self.nodeEditing = node
        self.maxValue = 360//maxValue
        self.minValue = 0//maxValue
        self.defaultValue = 0//def
        self.node = body
    }
    
}
