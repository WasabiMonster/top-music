//
//  AlbumDetailCoordinator.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailCoordinator: BaseCoordinator {
        
    init(presenter: UINavigationController, viewModel: AlbumDetailViewModel) {
        super.init(presenter: presenter)
        self.presenter = presenter
    }
    
}
