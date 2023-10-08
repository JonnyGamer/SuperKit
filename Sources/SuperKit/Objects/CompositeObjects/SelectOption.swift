//
//  SelectChatDirection.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/26/23.
//

import Foundation

class SelectOption<T: AnyObject, U: CaseIterable & RawRepresentable>: NodeView where U.RawValue == String {
    let text: String
    let getStatus: () -> U
    let setStatus: (U) -> ()
    var changedStatus: () -> () = {}
    
    deinit {
        sayGoodbye(self)
    }
    
    public var node: Node!
    public var body: Node {
        RoundWindow(width: 300, height: 150) {
            Padding(40) {
                VStack {
                    Padding(20) {
                        Window(width: 300, height: 25) {
                            Text(self.text)
                        }
                    }
                    this.vstack.spacing = 10
                    HStack {
                        this.hstack.spacing = 10
                        
                        for i in U.allCases {
                            
                            Button(width: 100, height: 100) {
                                Padding(5) {
                                    Text(i.rawValue)
                                }
                                this.whenTapped {
                                    self.setStatus(i)
                                    self.changedStatus()
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @discardableResult
    init(text: String, node: T, status: ReferenceWritableKeyPath<T, U>) {
        self.text = text
        self.getStatus = { node[keyPath: status] }
        self.setStatus = { node[keyPath: status] = $0 }
        self.node = body
    }
    
}
