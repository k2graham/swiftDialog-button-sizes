//
//  ButtonView.swift
//  dialog
//
//  Created by Bart Reardon on 10/3/21.
//

import Foundation
import SwiftUI

struct ButtonView: View {

    var button1action: String = ""
    var buttonShellAction: Bool = false
    
    var defaultExit : Int32 = 0
    var cancelExit  : Int32 = 2
    var infoExit    : Int32 = 3
    
    @State private var button1disabled = false
    
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect() //trigger after 4 seconds
    
    init() {
        if cloptions.button1ShellActionOption.present {
            button1action = cloptions.button1ShellActionOption.value
            buttonShellAction = true
        } else if cloptions.button1ActionOption.present {
            button1action = cloptions.button1ActionOption.value
        }
        
        if cloptions.timerBar.present && !cloptions.hideTimerBar.present {
            self._button1disabled = State(initialValue: true)
        }
    }
    
    var body: some View {
        //secondary button
        Spacer()
        HStack {
            if cloptions.button2Option.present {
                Button(action: {quitDialog(exitCode: appvars.exit2.code)}, label: {
                    Text(appvars.button2Default)
                        .frame(minWidth: 40, alignment: .center)
                    }
                )
                .keyboardShortcut(.cancelAction)
            } else if cloptions.button2TextOption.present {
                let button2Text: String = cloptions.button2TextOption.value
                Button(action: {quitDialog(exitCode: appvars.exit2.code)}, label: {
                    Text(button2Text)
                        .frame(minWidth: 40, alignment: .center)
                    }
                )
                .keyboardShortcut(.cancelAction)
            }
        }
        // default button aka button 1
        let button1Text: String = cloptions.button1TextOption.value

        Button(action: {buttonAction(action: self.button1action, exitCode: 0, executeShell: self.buttonShellAction)}, label: {
            Text(button1Text)
                .frame(minWidth: 40, alignment: .center)
            }
        )
        .keyboardShortcut(.defaultAction)
        .disabled(button1disabled)
        .onReceive(timer) { _ in
            button1disabled = false
        }

    }
}

struct MoreInfoButton: View {
    let buttonInfoAction: String = cloptions.buttonInfoActionOption.value
    var buttonInfoText : String = cloptions.buttonInfoTextOption.value
       
    var body: some View {
        HStack() {
            Button(action: {buttonAction(action: buttonInfoAction, exitCode: 3, executeShell: false, shouldQuit: cloptions.quitOnInfo.present)}, label: {
                Text(buttonInfoText)
                    .frame(minWidth: 40, alignment: .center)
                }
            )
            .onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
    
}
