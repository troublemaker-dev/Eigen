//
// AuthenticatedContentView.swift
// Eigen
//
        

import SwiftUI
import MatrixSDK

struct AuthenticatedContentView: View {
    @EnvironmentObject private var matrix: MatrixModel

    func fetch() {
        if matrix.syncStatus != .initialSync {
            matrix.syncStatus = .inProgress
        }
        matrix.session.setStore(matrix.store) { response in
            guard response.isSuccess else { return }

            matrix.session.start { response in
                guard response.isSuccess else { return }

                
//                MXCrypto.initializeCrypto(withMatrixSession: matrix.session) { crypto in
//                    if let crypto = crypto {
//                        startCrypto(crypto: crypto as! MXCrypto)
//                    } else {
//                        matrix.session.enableCrypto(true) { _ in
//                            startCrypto(crypto: matrix.session.crypto)
//                        }
//                    }
//                }
            }
        }
    }

    func startCrypto(crypto: MXCrypto) {
        crypto.start {
            matrix.syncStatus = .complete
        } failure: { e in
                print(e)
        }
    }

    var body: some View {
        ConversationList()
            .onAppear(perform: fetch)
            .onChange(of: matrix.session) { _ in
                fetch()
            }
    }
}

struct AuthenticatedContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedContentView()
    }
}
