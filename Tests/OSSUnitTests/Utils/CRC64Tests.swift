
@testable import AlibabaCloudOSS
import XCTest

class CRC64Tests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCRC64() throws {
        let data1 = "This is a case of test "
        let data2 = "for compute crc."
        let data = data1.appending(data2)

        var crc: UInt64 = 0
        crc = data.data(using: .utf8)!.withUnsafeBytes {
         CRC64.default.crc64(crc: crc, buf: $0.baseAddress!, len: $0.count)
        }
        XCTAssertEqual(crc, 7_500_711_509_069_051_972)

        crc = 0
        crc = data1.data(using: .utf8)!.withUnsafeBytes {
         CRC64.default.crc64(crc: crc, buf: $0.baseAddress!, len: $0.count)
        }
        crc = data2.data(using: .utf8)!.withUnsafeBytes {
         CRC64.default.crc64(crc: crc, buf: $0.baseAddress!, len: $0.count)
        }
        XCTAssertEqual(crc, 7_500_711_509_069_051_972)

        var crcCombine: UInt64 = 0
        let crc1 = data1.data(using: .utf8)!.withUnsafeBytes {
         CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }
        crcCombine = CRC64.default.crc64Combine(crc1: crcCombine, crc2: crc1, len2: uintmax_t(data1.count))
        let crc2 = data2.data(using: .utf8)!.withUnsafeBytes {
         CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }
        crcCombine = CRC64.default.crc64Combine(crc1: crcCombine, crc2: crc2, len2: uintmax_t(data2.count))

        XCTAssertEqual(crc, crcCombine)
    }

    #if !os(Linux) && !os(Windows)
//    func testCheckCRCInputStream() throws {
//        let fileUrl = Bundle.module.url(forResource: "example", withExtension: "jpeg")
//        let data = "This is a case of test CheckCRCInputStream.".data(using: .utf8)
//        let stream: SaveAndTransmitInterceptor.Stream = try {
//            var inputStream: InputStream? = nil
//            var outputStream: OutputStream? = nil
//            Foundation.Stream.getBoundStreams(withBufferSize: BufferStream.bufferSize,
//                                              inputStream: &inputStream,
//                                              outputStream: &outputStream)
//            guard let input = inputStream, let output = outputStream else {
//                throw ClientError.streamError("On return of `getBoundStreams`, both `inputStream` and `outputStream` will contain non-nil streams.")
//            }
//            return SaveAndTransmitInterceptor.Stream(inputStream: input, outputStream: output)
//        }()
//
//        var crcInputStream = CheckCRCInputStream(data: data!)
//        XCTAssertNoThrow(try read(inputStream: crcInputStream))
//        XCTAssertEqual(crcInputStream.crc, 4024488779742364033)
//
//
//        crcInputStream = CheckCRCInputStream(url: fileUrl!)!
//        XCTAssertNoThrow(try read(inputStream: crcInputStream))
//        XCTAssertEqual(crcInputStream.crc, 2311730852751352332)
//
//
//        OperationQueue().addOperation {
//            do {
//                let data = try Data(contentsOf: fileUrl!)
//                try self.write(outputStream: stream.outputStream, data: data)
//            } catch {
//                XCTFail()
//            }
//        }
//        crcInputStream = CheckCRCInputStream(inputStream: stream.inputStream)
//        XCTAssertNoThrow(try read(inputStream: crcInputStream))
//        XCTAssertEqual(crcInputStream.crc, 2311730852751352332)
//    }
//
//    func testCheckCRCOutputStream() throws {
//        let fileUrl = Bundle.module.url(forResource: "example", withExtension: "jpeg")
//        let stream: SaveAndTransmitInterceptor.Stream = try {
//            var inputStream: InputStream? = nil
//            var outputStream: OutputStream? = nil
//            Foundation.Stream.getBoundStreams(withBufferSize: BufferStream.bufferSize,
//                                              inputStream: &inputStream,
//                                              outputStream: &outputStream)
//            guard let input = inputStream, let output = outputStream else {
//                throw ClientError.streamError("On return of `getBoundStreams`, both `inputStream` and `outputStream` will contain non-nil streams.")
//            }
//            return SaveAndTransmitInterceptor.Stream(inputStream: input, outputStream: output)
//        }()
//
//        let crcOutputStream = CheckCRCOutputStream(outputStream: stream.outputStream)
//        OperationQueue().addOperation {
//            do {
//                try self.write(outputStream: crcOutputStream, data: try Data(contentsOf: fileUrl!))
//            } catch {
//                XCTFail()
//            }
//        }
//        try read(inputStream: stream.inputStream)
//        XCTAssertEqual(crcOutputStream.crc, 2311730852751352332)
//    }
    #endif

    // func read(inputStream: InputStream) throws {
    //     inputStream.open()
    //     var readLength = 0
    //     repeat {
    //         let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: BufferStream.bufferSize)
    //         readLength = inputStream.read(buffer, maxLength: BufferStream.bufferSize)
    //         if readLength == -1,
    //            let error = inputStream.streamError {
    //             throw error
    //         }
    //         if readLength == 0 {
    //             break
    //         }
    //         _ = Data(buffer: UnsafeBufferPointer(start: buffer, count: readLength))
    //         buffer.deallocate()
    //     } while true
    //     inputStream.close()
    // }

    // func write(outputStream: OutputStream, data: Data) throws {
    //     try data.withUnsafeBytes {
    //         guard var readBytes = $0.baseAddress else {
    //             return
    //         }
    //         let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: BufferStream.bufferSize)
    //         var writedLength = 0
    //         var len = $0.count > BufferStream.bufferSize ? BufferStream.bufferSize : $0.count
    //         outputStream.open()
    //         repeat {
    //             if len == 0 {
    //                 break
    //             }
    //             memcpy(buffer, readBytes, len)
    //             let realWriteLength = outputStream.write(buffer, maxLength: len)
    //             if realWriteLength == -1 {
    //                 if let error = outputStream.streamError {
    //                     throw error
    //                 } else {
    //                     throw ClientError.streamError("unknow stream error")
    //                 }
    //             }

    //             writedLength += realWriteLength
    //             readBytes += realWriteLength
    //             len = ($0.count - writedLength) > BufferStream.bufferSize ? BufferStream.bufferSize : ($0.count - writedLength)
    //         } while true
    //         buffer.deallocate()
    //         outputStream.close()
    //     }
    // }
}
