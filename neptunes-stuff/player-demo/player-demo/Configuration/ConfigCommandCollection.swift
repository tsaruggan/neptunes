//
//  ConfigCommandCollection.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-05-07.
//

import Foundation

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
`ConfigCommandCollection` is a group of related media commands.
*/

struct ConfigCommandCollection {
    
    // The displayable name of the collection.
    
    let collectionName: String
    
    // The commands that belong to this collection.
    
    var commands: [ConfigCommand]
    
    init(_ collectionName: String, commands allCommands: [ConfigCommand],
         registered registeredCommands: [NowPlayableCommand],
         disabled disabledCommands: [NowPlayableCommand]) {
        
        self.collectionName = collectionName
        self.commands = allCommands
        
        // Flag commands in this collection as needing to be disabled or registered,
        // as requested.
        
        for (index, command) in commands.enumerated() {
            
            if registeredCommands.contains(command.command) {
                commands[index].shouldRegister = true
            }
            
            if disabledCommands.contains(command.command) {
                commands[index].shouldDisable = true
            }
        }
    }
    
}

