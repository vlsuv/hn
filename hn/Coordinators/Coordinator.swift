//
//  Coordinator.swift
//  hn
//
//  Created by vlsuv on 26.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    func start()
    
    var childCoordinators: [Coordinator] { get }
    func childDidFinish(_ childCoordinator: Coordinator)
    
}

extension Coordinator {
    func childDidFinish(_ childCoordinator: Coordinator) {}
}
