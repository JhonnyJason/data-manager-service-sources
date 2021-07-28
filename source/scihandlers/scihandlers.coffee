
scihandlers = {}

############################################################
#region authentication
import auth from "./authmodule" 
import data from "./datamodule"
import session from "./sessionmodule"

############################################################
scihandlers.authenticate = auth.authenticateRequest

#endregion

############################################################
#region authenticationhandlers.coffee
############################################################
scihandlers.addClientToServe = (clientPublicKey, timestamp, signature) ->
    await auth.addClient(clientPublicKey)
    return {ok:true}


############################################################
scihandlers.getNodeId = (publicKey, timestamp, signature) ->
    return await auth.getSignedNodeId()
    ###
    
{
    "publicKey": "...",
    "timestamp": "...",
    "signature": "..."
}


    ###


############################################################
scihandlers.startSession = (publicKey, timestamp, signature) ->
    await auth.startSession(publicKey)
    return {ok:true}



#endregion

############################################################
#region datamanagementhandlers.coffee
############################################################
scihandlers.storeFile = (authCode, publicKey, fileName, fileContent) ->
    sessionInfo = session.getInfo(authCode)
    await data.storeFile(publicKey, fileName, fileContent, sessionInfo)
    return {ok: true}

############################################################
scihandlers.updateFile = (authCode, publicKey, fileName, fileContent) ->
    sessionInfo = session.getInfo(authCode)
    await data.updateFile(publicKey, fileName, fileContent, sessionInfo)
    return {ok: true}

############################################################
scihandlers.storeRestrictedFile = (authCode, publicKey, fileName, fileContent, keyNames) ->
    sessionInfo = session.getInfo(authCode)
    await data.storeRestrictedFile(publicKey, fileName, fileContent, keyNames, sessionInfo)
    return {ok: true}

############################################################
scihandlers.updateRestriction = (authCode, publicKey, fileName, keyNames, mode) ->
    sessionInfo = session.getInfo(authCode)
    await data.updateRestriction(publicKey, fileName, keyNames, mode, sessionInfo)
    return {ok: true}



#endregion



export default scihandlers