//
//  ChangeNumberValue.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/24/23.
//

class NumberSetting<T: AnyObject>: NodeView {
    let text: String
    private var _number: Double = 0.0
    let range: ClosedRange<Double>?
    let step: [Double]
    var number: Double { get { _number } set {
        guard let range = range else { _number = newValue; return }
        if let m = mod {
            if newValue < range.lowerBound { _number = newValue.truncatingRemainder(dividingBy: m) + range.upperBound; return }
            if newValue > range.upperBound { _number = newValue.truncatingRemainder(dividingBy: m) + range.lowerBound; return }
            _number = newValue
            //_number = min(range.upperBound, max(range.lowerBound, (newValue+m-step).truncatingRemainder(dividingBy: m)))
        } else {
            _number = min(range.upperBound, max(range.lowerBound, newValue))
        }
    } }
    let mod: Double?
    
    let getStatus: () -> Double
    let setStatus: (Double) -> ()
    
    public var node: Node!
    public var body: Node {
        RoundWindow(width: 300, height: 100) {
            Padding(50) {
                HStack {
                    this.hstack.spacing = 10
                    var numberText: Text!
                    
                    func updateValue(_ by: Double, reset: Bool = false) {
                        if reset { self.number = 0 }
                        self.number += by
                        self.setStatus(self.number)
                        numberText.__text__.text = "\(self.text): " + self.number.tenths
                    }
                    
                    for i in self.step.reversed() {
                        Button(width: 50, height: 50) {
                            Padding(10) {
                                Text("-")
                            }
                            this.whenTapped {
                                updateValue(-i)
                            }
                        }
                    }
                    
                    numberText = Text(self.text) { [self] in
                        number = getStatus()
                        this.text.text = "\(self.text): " + number.tenths
                    }
                    for i in self.step {
                        Button(width: 50, height: 50) {
                            Padding(10) {
                                Text("+")
                            }
                            this.whenTapped {
                                updateValue(i)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @discardableResult
    init(text: String, node: T, status: ReferenceWritableKeyPath<T, Double>, step: [Double], range: ClosedRange<Double>? = nil, mod: Double? = nil) {
        self.text = text
        self.getStatus = { node[keyPath: status] }
        self.setStatus = { node[keyPath: status] = $0 }
        self.range = range
        self.step = step
        self.mod = mod
        self.node = body
    }
    
}
