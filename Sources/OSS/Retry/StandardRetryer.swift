
import Foundation

public struct StandardRetryer: Retryer {
    private let maxAttempt: Int
    private let backoff: Backoff
    private let errorRetryable: [ErrorRetryable]

    public init(
        maxAttempt: Int? = nil,
        backoff: Backoff? = nil,
        errorRetryable: [ErrorRetryable]? = nil
    ) {
        self.maxAttempt = maxAttempt ?? Defaults.maxAttempt
        self.backoff = backoff ??
            FullJitterBackoff(
                baseDelay: Defaults.baseDelay,
                maxBackoff: Defaults.maxBackoff
            )
        self.errorRetryable = errorRetryable ??
            [ServiceErrorRetryable(), ClientErrorRetryable()]
    }

    public func maxAttempts() -> Int {
        return maxAttempt
    }

    public func isErrorRetryable(error: Error) -> Bool {
        for retryable in errorRetryable {
            if retryable.isErrorRetryable(error: error) {
                return true
            }
        }
        return false
    }

    public func retryDelay(attempt: Int, error: Error) -> TimeInterval {
        return backoff.backoffDelay(attempt: attempt, error: error)
    }
}
