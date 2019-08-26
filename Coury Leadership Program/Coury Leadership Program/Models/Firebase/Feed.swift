//
//  Feed.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

public class Feed: Fetchable {
    // shared instance
    public private(set) static var shared: Feed = {
        return Feed()
    }()

    // private instance properties
    private var hasCalendar = false {didSet {self.checkFetchSuccess()}}
    private var hasPolls = false {didSet {self.checkFetchSuccess()}}
    private var hasContent = false {didSet {self.checkFetchSuccess()}}

    private let calendarClosure: (Timer) -> Void = {_ in Database.shared.fetchCalendar()}
    private let pollsClosure: (Timer) -> Void = {_ in Database.shared.fetchPolls()}
    private let contentClosure: (Timer) -> Void = {_ in Database.shared.fetchContent()}

    private var calendarProcess: Timer {return Timer(timeInterval: 2.0, repeats: true, block: calendarClosure)}
    private var pollsProcess: Timer {return Timer(timeInterval: 2.0, repeats: true, block: pollsClosure)}
    private var contentProcess: Timer {return Timer(timeInterval: 2.0, repeats: true, block: contentClosure)}

    private var activeProcesses: [Timer] = []

    private var codeToRunAfterFetching: [() -> Void] = []

    private init() {
        registerCallbacks()
    }
    
    private func resetState() {
        hasCalendar = false
        hasPolls = false
        hasContent = false
    }

    public func beginFetching() {
        resetState()
        activeProcesses += [calendarProcess, pollsProcess, contentProcess]
        for process in activeProcesses {RunLoop.current.add(process, forMode: .common)}
    }
    
    public func isFetching() -> Bool {
        return activeProcesses.count > 0
    }

    public func stopFetching() {
        for process in activeProcesses {process.invalidate()}
        activeProcesses = []
    }

    public func onFetchSuccess(run block: @escaping () -> Void) {
        codeToRunAfterFetching.append(block)
    }

    public func clearFetchSuccessCallbacks() {
        codeToRunAfterFetching = []
    }

    private func checkFetchSuccess() {
        if (hasCalendar && hasPolls && hasContent) {
            stopFetching()
            for block in codeToRunAfterFetching {block()}
        }
    }

    private func registerCallbacks() {// TODO only set has___ to true if the result meets certain criteria?
        Database.shared.registerCalendarCallback {self.hasCalendar = true}
        Database.shared.registerPollsCallback {self.hasPolls = true}
        Database.shared.registerContentCallback {self.hasContent = true}
    }
}
