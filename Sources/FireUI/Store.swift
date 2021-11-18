//
//  Store.swift
//  
//
//  Created by Bri on 10/20/21.
//

@_exported import FirebaseCrashlytics
@_exported import StoreKit

public enum StoreProduct: String, Identifiable, CaseIterable, Codable {
    
    case noAds
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .noAds:
            return "circle"
        }
    }
}

public class Store: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published public var purchasedProducts: [StoreProduct] = []
    @Published public var error: Error?
    
    var onReceiveProductsHandler: ((Result<[SKProduct], PurchaseError>) -> Void)?
    var onBuyProductHandler: ((Result<[SKPaymentTransaction], Error>) -> Void)?
    
    var transactions: [SKPaymentTransaction] = []
    
    public func start() {
        SKPaymentQueue.default().add(self)
    }
    
    public func stop() {
        SKPaymentQueue.default().remove(self)
    }

    public func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func getProducts() {
        let productIdentifiers = Set(StoreProduct.allCases.map { $0.id })
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    public func price(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    public func buy(
        product: SKProduct,
        withHandler handler: @escaping ((_ result: Result<[SKPaymentTransaction], Error>) -> Void)
    ) {
        guard canMakePayments() else {
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
        onBuyProductHandler = handler
    }
    
    public func restorePurchases(withHandler handler: @escaping ((_ result: Result<[SKPaymentTransaction], Error>) -> Void)) {
        onBuyProductHandler = handler
        transactions = []
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public enum PurchaseError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
        var localizedDescription: String {
            switch self {
            case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
            case .noProductsFound: return "No In-App Purchases were found."
            case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
            case .paymentWasCancelled: return "In-App Purchase process was cancelled."
            }
        }
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        guard products.count > 0 else {
            onReceiveProductsHandler?(.failure(.noProductsFound))
            return
        }
        onReceiveProductsHandler?(.success(products))
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
    
    public func requestDidFinish(_ request: SKRequest) { }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                self.transactions.append(transaction)
                onBuyProductHandler?(.success([transaction]))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                self.transactions.append(transaction)
                onBuyProductHandler?(.success([transaction]))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error as? SKError {
                    if error.code != .paymentCancelled {
                        onBuyProductHandler?(.failure(error))
                    } else {
                        onBuyProductHandler?(.failure(PurchaseError.paymentWasCancelled))
                    }
                    print("IAP Error:", error.localizedDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if transactions.count > 0 {
            onBuyProductHandler?(.success(queue.transactions))
        } else {
            print("IAP: No purchases to restore!")
            onBuyProductHandler?(.success([]))
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                print("In App Purchase Restore Error:", error.localizedDescription)
                onBuyProductHandler?(.failure(error))
            } else {
                onBuyProductHandler?(.failure(PurchaseError.paymentWasCancelled))
            }
        }
    }
    
    private func didPurchase(_ transactions: Result<[SKPaymentTransaction], Error>) {
        DispatchQueue.main.async {
            switch transactions {
            case .success(let transactions):
                for transaction in transactions {
                    if let product = StoreProduct(rawValue: transaction.payment.productIdentifier) {
                        if self.purchasedProducts.contains(product), let index = self.purchasedProducts.firstIndex(of: product) {
                            self.purchasedProducts[index] = product
                        } else {
                            self.purchasedProducts.append(product)
                        }
                    }
                }
            case .failure(let error):
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    private func purchase(skProduct: SKProduct) {
        buy(product: skProduct) { result in
            self.didPurchase(result)
        }
    }

    func restorePurchases() {
        restorePurchases { result in
            self.didPurchase(result)
        }
    }
}
