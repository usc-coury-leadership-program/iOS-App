//
//  Fetchable.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 7/31/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import Foundation

public protocol Fetchable {
    func beginFetching()
    func isFetching() -> Bool
    func stopFetching()
    func onFetchSuccess(run block: @escaping () -> Void)
    func clearFetchSuccessCallbacks()
}
