//
//  GameViewInteractor.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

protocol GameViewInteractor {
    func tappedStartButton()
    func tappedGameButtonWithInput(input: RoundInput)
}