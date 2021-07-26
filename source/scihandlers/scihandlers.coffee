
scihandlers = {}

############################################################
#region authentication
import auth from "./authmodule" 
import data from "./datamodule"

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
    await data.storeFile(publicKey, fileName, fileContent)
    return {ok: true}

############################################################
scihandlers.updateFile = (authCode, publicKey, fileName, fileContent) ->
    await data.updateFile(publicKey, fileName, fileContent)
    return {ok: true}

############################################################
scihandlers.storeRestrictedFile = (authCode, publicKey, fileName, fileContent, keyNames) ->
    await data.storeRestrictedFile(publicKey, fileName, fileContent, keyNames)
    return {ok: true}

############################################################
scihandlers.updateRestriction = (authCode, publicKey, fileName, keyNames, mode) ->
    await data.updateRestriction(publicKey, fileName, keyNames, mode)
    return {ok: true}



#endregion



export default scihandlers