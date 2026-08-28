import Crypto
import Foundation

extension Data {
    func calculateMd5() -> Data {
        Data(Insecure.MD5.hash(data: self))
    }
}
