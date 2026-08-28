# Swift Package Verification

Verifies the published `AlibabaCloudOSS` Swift package works correctly across Apple platforms and Swift toolchains.

## Coverage

- Service: DescribeRegions, ListBuckets
- Bucket: Put, GetInfo, GetStat, GetLocation, Delete, GetAcl
- Object: Put, Head, GetMeta, Get, Copy, Delete
- Object Acl: Put, Get
- Object Tagging: Put, Get, Delete
- Object Symlink: Put, Get
- AppendObject / SealAppendObject
- Multipart: Initiate, UploadPart, UploadPartCopy, ListParts, ListMultipartUploads, Complete, Abort
- Presigner: pre-signed URL generation and access
- Paginator: ListObjects, ListObjectsV2, ListBuckets
- Extensions: IsBucketExist, IsObjectExist
- DeleteMultipleObjects

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OSS_ACCESS_KEY_ID` | AccessKey ID (required) |
| `OSS_ACCESS_KEY_SECRET` | AccessKey Secret (required) |
| `OSS_SESSION_TOKEN` | STS Token (optional) |

## Usage

```bash
# macOS
swift run PackageVerify

# iOS Simulator
xcrun swift run PackageVerify --destination 'platform=iOS Simulator,name=iPhone 17'

# Linux
swift run PackageVerify
