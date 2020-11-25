// Generated by zkgroup/codegen/codegen.py - do not edit

import Foundation
import libzkgroup

public class ClientZkProfileOperations {

  let serverPublicParams: ServerPublicParams

  public init(serverPublicParams: ServerPublicParams) {
    self.serverPublicParams = serverPublicParams
  }

  public func createProfileKeyCredentialRequestContext(uuid: ZKGUuid, profileKey: ProfileKey) throws  -> ProfileKeyCredentialRequestContext {
    var randomness: [UInt8] = Array(repeating: 0, count: Int(32))
    let result = SecRandomCopyBytes(kSecRandomDefault, randomness.count, &randomness)
    guard result == errSecSuccess else {
      throw ZkGroupException.AssertionError
    }

    return try createProfileKeyCredentialRequestContext(randomness: randomness, uuid: uuid, profileKey: profileKey)
  }

  public func createProfileKeyCredentialRequestContext(randomness: [UInt8], uuid: ZKGUuid, profileKey: ProfileKey) throws  -> ProfileKeyCredentialRequestContext {
    var newContents: [UInt8] = Array(repeating: 0, count: ProfileKeyCredentialRequestContext.SIZE)

    let ffi_return = FFI_ServerPublicParams_createProfileKeyCredentialRequestContextDeterministic(serverPublicParams.getInternalContentsForFFI(), UInt32(serverPublicParams.getInternalContentsForFFI().count), randomness, UInt32(randomness.count), uuid.getInternalContentsForFFI(), UInt32(uuid.getInternalContentsForFFI().count), profileKey.getInternalContentsForFFI(), UInt32(profileKey.getInternalContentsForFFI().count), &newContents, UInt32(newContents.count))

    if (ffi_return != Native.FFI_RETURN_OK) {
      throw ZkGroupException.ZkGroupError
    }

    do {
      return try ProfileKeyCredentialRequestContext(contents: newContents)
    } catch ZkGroupException.InvalidInput {
      throw ZkGroupException.AssertionError
    }

  }

  public func receiveProfileKeyCredential(profileKeyCredentialRequestContext: ProfileKeyCredentialRequestContext, profileKeyCredentialResponse: ProfileKeyCredentialResponse) throws  -> ProfileKeyCredential {
    var newContents: [UInt8] = Array(repeating: 0, count: ProfileKeyCredential.SIZE)

    let ffi_return = FFI_ServerPublicParams_receiveProfileKeyCredential(serverPublicParams.getInternalContentsForFFI(), UInt32(serverPublicParams.getInternalContentsForFFI().count), profileKeyCredentialRequestContext.getInternalContentsForFFI(), UInt32(profileKeyCredentialRequestContext.getInternalContentsForFFI().count), profileKeyCredentialResponse.getInternalContentsForFFI(), UInt32(profileKeyCredentialResponse.getInternalContentsForFFI().count), &newContents, UInt32(newContents.count))
    if (ffi_return == Native.FFI_RETURN_INPUT_ERROR) {
      throw ZkGroupException.VerificationFailed
    }

    if (ffi_return != Native.FFI_RETURN_OK) {
      throw ZkGroupException.ZkGroupError
    }

    do {
      return try ProfileKeyCredential(contents: newContents)
    } catch ZkGroupException.InvalidInput {
      throw ZkGroupException.AssertionError
    }

  }

  public func createProfileKeyCredentialPresentation(groupSecretParams: GroupSecretParams, profileKeyCredential: ProfileKeyCredential) throws  -> ProfileKeyCredentialPresentation {
    var randomness: [UInt8] = Array(repeating: 0, count: Int(32))
    let result = SecRandomCopyBytes(kSecRandomDefault, randomness.count, &randomness)
    guard result == errSecSuccess else {
      throw ZkGroupException.AssertionError
    }

    return try createProfileKeyCredentialPresentation(randomness: randomness, groupSecretParams: groupSecretParams, profileKeyCredential: profileKeyCredential)
  }

  public func createProfileKeyCredentialPresentation(randomness: [UInt8], groupSecretParams: GroupSecretParams, profileKeyCredential: ProfileKeyCredential) throws  -> ProfileKeyCredentialPresentation {
    var newContents: [UInt8] = Array(repeating: 0, count: ProfileKeyCredentialPresentation.SIZE)

    let ffi_return = FFI_ServerPublicParams_createProfileKeyCredentialPresentationDeterministic(serverPublicParams.getInternalContentsForFFI(), UInt32(serverPublicParams.getInternalContentsForFFI().count), randomness, UInt32(randomness.count), groupSecretParams.getInternalContentsForFFI(), UInt32(groupSecretParams.getInternalContentsForFFI().count), profileKeyCredential.getInternalContentsForFFI(), UInt32(profileKeyCredential.getInternalContentsForFFI().count), &newContents, UInt32(newContents.count))

    if (ffi_return != Native.FFI_RETURN_OK) {
      throw ZkGroupException.ZkGroupError
    }

    do {
      return try ProfileKeyCredentialPresentation(contents: newContents)
    } catch ZkGroupException.InvalidInput {
      throw ZkGroupException.AssertionError
    }

  }

}
