import Foundation
import CommonCrypto

class AESCrypt {
    
    static var key : Data {
        let secretKey = "Chaintech-Task@2"
        return secretKey.data(using: .utf8) ?? Data()
    }
    
    class func encryptECB(data: Data, key: Data = AESCrypt.key) -> Data? {
        let keyLength = kCCKeySizeAES128
        let dataLength = data.count
        
        let cryptLength = dataLength + kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES128),
                        CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, keyLength,
                        nil,
                        dataBytes.baseAddress, dataLength,
                        cryptBytes.baseAddress, cryptLength,
                        &numBytesEncrypted
                    )
                }
            }
        }
        
        if cryptStatus == kCCSuccess {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            return cryptData
        } else {
            return nil
        }
    }
    
    class func decryptECB(message: String, key: Data = AESCrypt.key) -> Data? {
        let data = Data(base64Encoded: message, options: .ignoreUnknownCharacters) ?? Data()
        let keyLength = kCCKeySizeAES128
        let dataLength = data.count
        
        let cryptLength = dataLength + kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)
        
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES128),
                        CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, keyLength,
                        nil,
                        dataBytes.baseAddress, dataLength,
                        cryptBytes.baseAddress, cryptLength,
                        &numBytesDecrypted
                    )
                }
            }
        }
        
        if cryptStatus == kCCSuccess {
            cryptData.removeSubrange(numBytesDecrypted..<cryptData.count)
            return cryptData
        } else {
            return nil
        }
    }
}


class CommonMethod{
    static let shared = CommonMethod()
    func convertDecryptString(decrypted: Data) -> String {
        String(data: decrypted, encoding: .utf8) ?? ""
    }
}


