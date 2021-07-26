
scihandlers = {}

############################################################
#region authentication
import auth from "./authmodule" 

############################################################
scihandlers.authenticate = auth.authenticateRequest

#endregion

############################################################
#region authenticationhandlers.coffee
############################################################
scihandlers.addClientToServe = (clientPublicKey, timestamp, signature) ->
    result = {}
    ###
    
{
    "ok": true
}


    ###
    return result


############################################################
scihandlers.getNodeId = (publicKey, timestamp, signature) ->
    result = {}
    ###
    
{
    "publicKey": "...",
    "timestamp": "...",
    "signature": "..."
}


    ###
    return result


############################################################
scihandlers.startSession = (publicKey, timestamp, signature) ->
    result = {}
    ###
    
{
    "ok": true
}


    ###
    return result



#endregion

############################################################
#region datamanagementhandlers.coffee
############################################################
scihandlers.storeFile = (authCode, publicKey, fileName, fileContent) ->
    result = {}
    ###
    
{
    "ok": true
}

    ###
    return result


############################################################
scihandlers.updateFile = (authCode, publicKey, fileName, fileContent) ->
    result = {}
    ###
    
{
    "ok": true
}

    ###
    return result


############################################################
scihandlers.storeRestrictedFile = (authCode, publicKey, fileName, fileContent, keyNames) ->
    result = {}
    ###
    
{
    "ok": true
}

    ###
    return result


############################################################
scihandlers.updateRestriction = (authCode, publicKey, fileName, keyNames, mode) ->
    result = {}
    ###
    
{
    "ok": true
}

    ###
    return result



#endregion



export default scihandlers