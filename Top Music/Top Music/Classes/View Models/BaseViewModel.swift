//
//  BaseViewModel.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation

protocol BaseViewModel {
    // var didTapBack: (() -> Void)? { get set }
}

extension BaseViewModel {
    /* func errorMessage(withError error: Error) -> String {
        // Perform UI updates on main thread
        guard let networkError = error as? ApiError else {
            return error.localizedDescription
        }
        
        var errorMessage = ""
        switch networkError {
        case .malformedURL:
            errorMessage = "malformed url"
        case .failedRequest:
            errorMessage = "failed request"
        case .receivedInvalidData:
            errorMessage = "received data is not readable"
        case .failedToStoreCredentials:
            errorMessage = "credentials could not be saved"
        }
        return errorMessage
    } */
}
