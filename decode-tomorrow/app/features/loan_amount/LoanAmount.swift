//
//  LoanAmount.swift
//  decode-tomorrow
//
//  Created by Mark on 11/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import RxSwift

struct LoanAmountResp: Decodable {
    let loanAmount: Int
}

class MeFetcher {
    
    static let shared = MeFetcher()
    
    private var dbag = DisposeBag()
    
    func getLoanAmount(resp: @escaping ((Error?, Int?) -> Void)) {
        Provider.sharedRx.request(.me).mapX(LoanAmountResp.self, dBag: dbag) { (event) in
            switch event {
            case .next(let value):
                resp(nil, value.loanAmount)
            case .error(let error):
                resp(error, nil)
            case .completed:
                break
            }
        }
    }
    
    func markStatusAsDone(resp: @escaping ((Error?) -> Void)) {
        Provider.sharedRx.request(.markStatusAsDone).mapX(EmptyResponse.self, dBag: dbag) { (event) in
            switch event {
            case .next:
                resp(nil)
            case .error(let error):
                resp(error)
            case .completed:
                break
            }
        }
    }
    
}
