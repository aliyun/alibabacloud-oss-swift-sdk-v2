import Atomics
import XCTest

@testable import AlibabaCloudOSS

final class ExpiringValueTests: XCTestCase {
    /// Test value returned from closure is given back
    func testValue() async throws {
        let expiringValue = ExpiringValue<Int>()
        let value = try await expiringValue.getValue {
            try await Task.sleep(nanoseconds: 1000)
            return (1, Date())
        }
        XCTAssertEqual(value, 1)
    }

    /// Test an expired value is updated
    func testExpiredValue() async throws {
        // Expiry must be strictly in the past: an expiry equal to now is
        // classified as "about to expire" and returns the stale value.
        let expiringValue = ExpiringValue<Int>(0, expires: Date().addingTimeInterval(-1))
        let value = try await expiringValue.getValue {
            try await Task.sleep(nanoseconds: 1000)
            return (1, Date())
        }
        XCTAssertEqual(value, 1)
    }

    /// Test when a value is just about to expire it returns current value and kicks off
    /// new task to get new value
    #if swift(>=5.9) // makeStream doesn't exist in earlier versions of swift
        func testJustAboutToExpireValue() async throws {
            // Keep a wide margin between expiry and threshold so scheduler
            // stalls cannot turn "about to expire" into "expired".
            let threshold: TimeInterval = 60
            let expiringValue = ExpiringValue<Int>(0, expires: Date() + threshold / 2, threshold: threshold)
            let (stream, source) = AsyncStream<Void>.makeStream()
            let value = try await expiringValue.getValue {
                source.finish()
                try await Task.sleep(nanoseconds: 1000)
                return (1, Date())
            }
            await stream.first { _ in true }
            // test it return current value
            XCTAssertEqual(value, 0)
        }
    #endif

    /// Test closure is not called if value has not expired
    func testClosureNotCalled() async throws {
        let called = ManagedAtomic(false)
        let expiringValue = ExpiringValue<Int>(0, expires: Date.distantFuture, threshold: 1)
        let value = try await expiringValue.getValue {
            called.store(true, ordering: .relaxed)
            try await Task.sleep(nanoseconds: 1000)
            return (1, Date())
        }
        XCTAssertEqual(value, 0)
        XCTAssertEqual(called.load(ordering: .relaxed), false)
    }

    /// Test closure is only called once even though we asked for value 100 times
    func testClosureCalledOnce() async throws {
        let callCount = ManagedAtomic(0)
        let expiringValue = ExpiringValue<Int>()
        try await withThrowingTaskGroup(of: Int.self) { group in
            for _ in 0 ..< 100 {
                group.addTask {
                    try await expiringValue.getValue {
                        callCount.wrappingIncrement(by: 1, ordering: .relaxed)
                        try await Task.sleep(nanoseconds: 100_000)
                        return (123, Date.distantFuture)
                    }
                }
            }
            for try await result in group {
                XCTAssertEqual(result, 123)
            }
        }
        XCTAssertEqual(callCount.load(ordering: .relaxed), 1)
    }

    /// Test value returned from closure is given back
    func testInitialClosure() async throws {
        let expiringValue = ExpiringValue<Int> {
            try await Task.sleep(nanoseconds: 1000)
            return (1, Date() + 3)
        }
        let value = try await expiringValue.getValue {
            (2, Date())
        }
        XCTAssertEqual(value, 1)
    }
}
