authmodule = {name: "authmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["authmodule"]?  then console.log "[authmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
specialAuth = {
    "addClientToServe": authenticateClientAdd, 
    "getNodeId": isKnownClientSignature,
    "startSession": isKnownClientSignature
}

############################################################
authmodule.initialize = () ->
    log "authmodule.initialize"
    return

############################################################
#region internal Functions
authenticateClientAdd = (req) ->
    log "authenticateClientAdd"
    olog req.body
    return

isKnownClientSignature = (req) ->
    log "isKnownClientSignature"
    olog req.body
    return

isValidAuthCode = (code) ->
    log "isValidAuthCode"
    olog {code}
    return

#endregion

############################################################
authmodule.authenticateRequest = (req, res, next) ->
    try
        if specialAuth[req.path]? 
            if specialAuth[req.path](req) then next()
            else throw new Error("Wrong Special Auth!")
        else if isValidAuthCode(req.body.authCode) then next()
        else throw new Error("Wrong Auth Code!")
    catch err then res.send({error: err.stack})

############################################################
authmodule.getSignedNodeId = ->
    result = {
        "publicKey": "...",
        "timestamp": "...",
        "signature": "..."
    }
    return result

############################################################
authmodule.addClient = (publicKey) ->
    log "authmodule.addClient"
    return

############################################################
authmodule.startSession = (publicKey) ->
    log "authmodule.startSession"
    return
    
module.exports = authmodule