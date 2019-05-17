//
//  QRScannerModule.swift
//  QRScannerModule
//
//  Created by  Vitaly Potlov on 26/04/2019.
//

import Foundation
import IBACore
import IBACoreUI

public class QRScannerModule: BaseModule, ModuleType {
    
    public var moduleRouter: AnyRouter { return router }
    
    private var router: QRScannerModuleRouter!
    internal var config: WidgetModel?
    internal var data: DataModel?
    
    public override class func canHandle(config: WidgetModel) -> Bool {
        return config.type == "barcode" ? true : false
    }
    
    public required init() {
        print("\(type(of: self)).\(#function)")
        super.init()
        router = QRScannerModuleRouter(with: self)
    }
    
    public func setConfig(_ model: WidgetModel) {
        self.config = model
        if let data = model.data, let dataModel = DataModel(map: data) {
            self.data = dataModel
        } else {
            print("Error parsing!")
        }
    }
}
