//
//  GameViewController.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class GameViewController: UIViewController {

    private var gamePresenter : protocol<GameViewInteractorType,GameViewModelType>?

    private lazy var startButton : UIButton = {
        let button = UIButton.mainGameButton()
        button.setTitle("Tap to start!", forState: .Normal)
        return button
    }()

    private lazy var hudView : HUDView = HUDView()
    private lazy var wordView : WordView = WordView()
    private lazy var gameView : GameView = GameView()

    private lazy var correctButton : UIButton = {
        let button = UIButton.mainGameButton()
        button.setTitle("Correct", forState: .Normal)
        return button
    }()
    private lazy var wrongButton : UIButton = {
        let button = UIButton.mainGameButton()
        button.setTitle("Wrong", forState: .Normal)
        return button
    }()

    private let disposeBag = DisposeBag()

    // MARK: View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Falling Words"
        self.view.backgroundColor = UIColor.mainGameColor()

        self.view.addSubview(hudView)
        self.view.addSubview(wordView)
        self.view.addSubview(gameView)
        self.view.addSubview(startButton)
        self.view.addSubview(correctButton)
        self.view.addSubview(wrongButton)

        setDefaultConstraints()
        setMenuLayout()

        self.gamePresenter = GamePresenter(languageOne: .English, languageTwo: .Spanish)
        self.bindViewModel(self.gamePresenter!)
        self.bindInteractor(self.gamePresenter!)
    }

    private func setDefaultConstraints() {

        startButton.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp_center)
            make.size.equalTo(CGSize(width: UI.Unit * 60, height: UI.Unit * 11))
        }

        hudView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(UI.DefaultPadding)
            make.right.equalTo(view.snp_right).offset(-UI.DefaultPadding)
            make.top.equalTo(view.snp_top).offset(UI.DefaultPadding)
            make.height.equalTo(UI.Unit*8)
        }

        wordView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(UI.DefaultPadding)
            make.right.equalTo(view.snp_right).offset(-UI.DefaultPadding)
            make.top.equalTo(hudView.snp_bottom).offset(UI.DefaultPadding)
            make.height.equalTo(UI.Unit*8)
        }

        gameView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(UI.DefaultPadding)
            make.right.equalTo(view.snp_right).offset(-UI.DefaultPadding)
            make.top.equalTo(wordView.snp_bottom).offset(UI.DefaultPadding)
            make.bottom.equalTo(correctButton.snp_top).offset(-UI.DefaultPadding)
        }

        correctButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(UI.DefaultPadding)
            make.bottom.equalTo(view.snp_bottom).offset(-UI.DefaultPadding)
            make.right.equalTo(view.snp_centerX)
            make.height.equalTo(UI.Unit*16)
        }

        wrongButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(correctButton.snp_right).offset(UI.DefaultPadding)
            make.bottom.equalTo(view.snp_bottom).offset(-UI.DefaultPadding)
            make.right.equalTo(view.snp_right).offset(-UI.DefaultPadding)
            make.height.equalTo(correctButton.snp_height)
        }
    }

    private func setMenuLayout() {
        self.startButton.hidden = false
        self.correctButton.hidden = true
        self.wrongButton.hidden = true
        self.wordView.hidden = true
    }

    private func setInGameLayout() {
        self.startButton.hidden = true
        self.correctButton.hidden = false
        self.wrongButton.hidden = false
        self.wordView.hidden = false
    }

    // MARK: Interactor and button events (push)

    private func bindInteractor(interactor: GameViewInteractorType) {
        setStartButtonTapEventWithInteractor(interactor)
        setCorrectButtonTapEventWithInteractor(interactor)
        setWrongButtonTapEventWithInteractor(interactor)
    }

    private func setStartButtonTapEventWithInteractor(interactor: GameViewInteractorType) {
        startButton.rx_tap.subscribeNext { [unowned self] () -> Void in
            self.setInGameLayout()
            interactor.tappedStartButton()
        }.addDisposableTo(disposeBag)
    }

    private func setCorrectButtonTapEventWithInteractor(interactor: GameViewInteractorType) {
        correctButton.rx_tap.subscribeNext { () -> Void in
            interactor.tappedGameButtonWithInput(.CorrectButtonTapped)
        }.addDisposableTo(disposeBag)
    }

    private func setWrongButtonTapEventWithInteractor(interactor: GameViewInteractorType) {
        wrongButton.rx_tap.subscribeNext { () -> Void in
            interactor.tappedGameButtonWithInput(.WrongButtonTapped)
        }.addDisposableTo(disposeBag)
    }

    // MARK: ViewModel and Game events

    private func bindViewModel(viewModel: GameViewModelType) {
        bindViewModelToHUDScore(viewModel)
        bindViewModelToHUDCountdown(viewModel)
        bindViewModelToWordLabels(viewModel)
        observeViewModelNewRoundEvent(viewModel)
        observeViewModelGameOverEvent(viewModel)
        observeViewModelDidFinishRoundEvent(viewModel)
    }

    private func bindViewModelToHUDCountdown(viewModel: GameViewModelType) {
        viewModel.countDownText().observeOn(MainScheduler.instance).subscribeNext { [unowned self] (secondString) -> Void in
            self.hudView.updateCountdownLabelWithString(secondString)
        }.addDisposableTo(disposeBag)
    }

    private func bindViewModelToHUDScore(viewModel: GameViewModelType) {
        viewModel.scoreText().observeOn(MainScheduler.instance).subscribeNext { [unowned self] (scoreString) -> Void in
            self.hudView.updateScoreLabelWithString(scoreString)
        }.addDisposableTo(disposeBag)
    }

    private func bindViewModelToWordLabels(viewModel: GameViewModelType) {
        Observable.combineLatest(viewModel.currentWordToGuess(),
            viewModel.currentOption()
            ) { (currentWordToGuess, currentOption) -> (String, String) in
                return (currentWordToGuess, currentOption)
            }.observeOn(MainScheduler.instance)
            .subscribeNext { [unowned self] (words) -> Void in
                self.wordView.updateWordLabelWithString(words.0)
                self.gameView.setFallingLabelText(words.1)
        }.addDisposableTo(disposeBag)
    }

    private func observeViewModelNewRoundEvent(viewModel: GameViewModelType) {
        viewModel.didStartNewRoundEvent().observeOn(MainScheduler.instance).subscribeNext { [unowned self] (_) -> Void in
            self.gameView.startFallingLabelAnimationWithDuration(Double(viewModel.roundDuration()))
        }.addDisposableTo(disposeBag)
    }

    private func observeViewModelGameOverEvent(viewModel: GameViewModelType) {
        viewModel.gameOverEventWithScore().observeOn(MainScheduler.instance).subscribeNext { [unowned self] (_) -> Void in
            self.startButton.setTitle("Game over! Tap to restart", forState: .Normal)
            self.gameView.stopFallingLabelAnimation()
            self.setMenuLayout()
        }.addDisposableTo(disposeBag)
    }

    private func observeViewModelDidFinishRoundEvent(viewModel: GameViewModelType) {
        viewModel.didFinishRoundEventDidWin().observeOn(MainScheduler.instance).subscribeNext { [unowned self] (didWin) -> Void in
            if didWin {
                self.gameView.blinkWithColor(UIColor.greenColor())
            } else {
                self.gameView.blinkWithColor(UIColor.redColor())
            }
        }.addDisposableTo(disposeBag)
    }
}

