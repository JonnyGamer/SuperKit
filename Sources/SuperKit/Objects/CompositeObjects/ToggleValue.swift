//
//  ToggleValue.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/24/23.
//

class ToggleSetting<T: AnyObject>: NodeView {
    let text: String
    var getStatus: () -> Bool
    var setStatus: (Bool) -> ()
    
    deinit {
        sayGoodbye(self)
    }
    
    public var node: Node!
    public var body: Node {
        return RoundWindow(width: 300, height: 100) {
            Padding(50) {
                HStack {
                    this.hstack.spacing = 10
                    Text(self.text)
                    Toggle(status: true) {
                        this.toggle.setState(self.getStatus())
                        this.whenTapped {
                            self.setStatus(this.toggle.__on)
                        }
                    }
                }
            }
        }
    }
    
    @discardableResult
    init(text: String, node: T, status: ReferenceWritableKeyPath<T, Bool>) {
        self.text = text
        self.getStatus = { node[keyPath: status] }
        self.setStatus = { node[keyPath: status] = $0 }
        self.node = body
        sayHello(self)
    }
    
}
