//
//  SFSafariCoordinator.swift
//  hn
//
//  Created by vlsuv on 28.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import SafariServices

class SFSafariCoordinator: NSObject, Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyBuilderProtocol
    
    private let url: URL
    
    init(navigationController: UINavigationController, url: URL) {
        self.navigationController = navigationController
        
        self.url = url
        
        self.assemblyBuilder = AssemblyBuilder()
    }
    
    // MARK: - Init
    func start() {
        let safariController = assemblyBuilder.createSafariController(with: url)
        safariController.delegate = self
        
        navigationController.present(safariController, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit: \(self)")
    }
}

// MARK: - SFSafariViewControllerDelegate
extension SFSafariCoordinator: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        parentCoordinator?.childDidFinish(self)
    }
}
