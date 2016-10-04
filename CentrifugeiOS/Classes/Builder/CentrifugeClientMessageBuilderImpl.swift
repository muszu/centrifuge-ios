//
//  CentrifugeClientMessageBuilderImpl.swift
//  Pods
//
//  Created by Herman Saprykin on 18/04/16.
//
//

import IDZSwiftCommonCrypto

protocol CentrifugeClientMessageBuilder {
    func buildConnectMessage(credentials: CentrifugeCredentials) -> CentrifugeClientMessage
    func buildDisconnectMessage() -> CentrifugeClientMessage
    func buildSubscribeMessageTo(channel: String) -> CentrifugeClientMessage
    func buildSubscribeMessageTo(channel: String, lastMessageUUID: String) -> CentrifugeClientMessage
    func buildUnsubscribeMessageFrom(channel: String) -> CentrifugeClientMessage
    func buildPresenceMessage(channel: String) -> CentrifugeClientMessage
    func buildHistoryMessage(channel: String) -> CentrifugeClientMessage
    func buildPingMessage() -> CentrifugeClientMessage
    func buildPublishMessageTo(channel: String, data: [String: AnyObject]) -> CentrifugeClientMessage
}

class CentrifugeClientMessageBuilderImpl: CentrifugeClientMessageBuilder {

    func buildConnectMessage(credentials: CentrifugeCredentials) -> CentrifugeClientMessage {

        let user = credentials.user, timestamp = credentials.timestamp, token = credentials.token

        var params = ["user" : user,
                      "timestamp" : timestamp,
                      "token" : token]

        if let info = credentials.info {
            params["info"] = info
        }

        return buildMessage(.Connect, params: params)
    }

    func buildDisconnectMessage() -> CentrifugeClientMessage {
        return buildMessage(.Disconnect, params: [:])
    }

    func buildSubscribeMessageTo(channel: String) -> CentrifugeClientMessage {
        let params = ["channel" : channel]
        return buildMessage(.Subscribe, params: params)
    }

    func buildSubscribeMessageTo(channel: String, lastMessageUUID: String) -> CentrifugeClientMessage {
        let params = ["channel" : channel,
                      "recover" : true,
                      "last" : lastMessageUUID]
        return buildMessage(.Subscribe, params: params as! [String : AnyObject])
    }

    func buildUnsubscribeMessageFrom(channel: String) -> CentrifugeClientMessage {
        let params = ["channel" : channel]
        return buildMessage(.Unsubscribe, params: params)
    }

    func buildPublishMessageTo(channel: String, data: [String : AnyObject]) -> CentrifugeClientMessage {
        let params:[String : AnyObject] = ["channel" : channel,
                                           "data" : data]
        return buildMessage(.Publish, params: params)
    }

    func buildPresenceMessage(channel: String) -> CentrifugeClientMessage {
        let params:[String : AnyObject] = ["channel" : channel]
        return buildMessage(.Presence, params: params)
    }

    func buildHistoryMessage(channel: String) -> CentrifugeClientMessage {
        let params:[String : AnyObject] = ["channel" : channel]
        return buildMessage(.History, params: params)
    }

    func buildPingMessage() -> CentrifugeClientMessage {
        return buildMessage(.Ping, params: [:])
    }

    private func buildMessage(method: CentrifugeMethod, params: [String: AnyObject]) -> CentrifugeClientMessage {
        let uid = generateUUID()
        let message = CentrifugeClientMessage(uid: uid, method: method, params: params)
        return message
    }

    private func generateUUID() -> String {
        return NSUUID().UUIDString
    }
}
