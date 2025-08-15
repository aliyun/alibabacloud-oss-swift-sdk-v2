import Foundation

public struct HttpRequestOptions {
    public var progressDelegate: ProgressDelegateDesc?
    public let saveToURL: Bool?
    
    public init(
        progressDelegate: ProgressDelegateDesc?,
        saveToURL: Bool?
    ) {
        self.progressDelegate = progressDelegate
        self.saveToURL = saveToURL
    }
}
