import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutBucketInventory
extension Serde {
    static func serializePutBucketInventory (
        _ request: inout PutBucketInventoryRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.inventoryId {
            input.parameters["inventoryId"] = value
        }
        
        let data: Data = try XMLEncoder().encode(request.inventoryConfiguration, withRootKey: "InventoryConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketInventory (
        _ result: inout PutBucketInventoryResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketInventory
extension Serde {
    static func serializeGetBucketInventory (
        _ request: inout GetBucketInventoryRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.inventoryId {
            input.parameters["inventoryId"] = value
        }
        
    }

    static func deserializeGetBucketInventory (
        _ result: inout GetBucketInventoryResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let inventoryConfiguration = try XMLDecoder().decode(InventoryConfiguration.self, from: data)
        result.inventoryConfiguration = inventoryConfiguration
         
    }
}


// MARK: - ListBucketInventory
extension Serde {
    static func serializeListBucketInventory (
        _ request: inout ListBucketInventoryRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.continuationToken {
            input.parameters["continuation-token"] = value
        }
        
    }

    static func deserializeListBucketInventory (
        _ result: inout ListBucketInventoryResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let listInventoryConfigurationsResult = try XMLDecoder().decode(ListInventoryConfigurationsResult.self, from: data)
        result.listInventoryConfigurationsResult = listInventoryConfigurationsResult
         
    }
}


// MARK: - DeleteBucketInventory
extension Serde {
    static func serializeDeleteBucketInventory (
        _ request: inout DeleteBucketInventoryRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.inventoryId {
            input.parameters["inventoryId"] = value
        }
        
    }

    static func deserializeDeleteBucketInventory (
        _ result: inout DeleteBucketInventoryResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


