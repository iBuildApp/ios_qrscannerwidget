//
//  QRScannerModuleRouter.swift
//  QRScannerModule
//
//  Created by  Vitaly Potlov on 26/04/2019.
//

import Foundation
import IBACore
import IBACoreUI

public enum QRScannerModuleRoute: Route {
    case root
}

public class QRScannerModuleRouter: BaseRouter<QRScannerModuleRoute> {
    var module: QRScannerModule?
    init(with module: QRScannerModule) {
        self.module = module
    }

    public override func generateRootViewController() -> BaseViewControllerType {
        return QRScannerViewController(type: module?.config?.type, data: module?.data)
    }
    
    public override func prepareTransition(for route: QRScannerModuleRoute) -> RouteTransition {
        var options = TransitionOptions(animated: true)
        options.type = .modal
        return RouteTransition(module: generateRootViewController(), options: options)
    }
    
    public override func rootTransition() -> RouteTransition {
        return self.prepareTransition(for: .root)
    }
}
