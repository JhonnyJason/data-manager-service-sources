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
cfg = null
session = null
decay = null

############################################################
specialAuth = null
validCodeMemory = {}

############################################################
authmodule.initialize = ->
    log "authmodule.initialize"

    cfg = allModules.configmodule
    session = allModules.sessionmodule
    decay = allModules.memorydecaymodule

    ########################################################
    ## TODO remove this code!
    validCodeMemory["..."] = {text:"I am a session!"}
    ##

    decay.createMemoryObjectFor(validCodeMemory)
    

    ########################################################
    specialAuth = cfg.specialAuth
    if !specialAuth? then specialAuth = {}

    keys = Object.keys(specialAuth)
    for key in keys
        specialAuth[key] = specialAuthFunctionFor(specialAuth[key])

    Object.freeze(specialAuth)
    return

############################################################
#region internal Functions
specialAuthFunctionFor = (typeString) ->
    if typeString == "masterSignature" then return isMasterSignature
    if typeString == "knownClientSignature" then return isKnownClientSignature
    throw new Error("Invalid specialAuth typeString in config: '"+typeString+"' !")
    return

############################################################
isMasterSignature = (req) ->
    log "isMasterSignature"
    olog req.body
    return true

isKnownClientSignature = (req) ->
    log "isKnownClientSignature"
    olog req.body
    return true

############################################################
isValidAuthCode = (code) ->
    log "isValidAuthCode"
    olog {code}
    throw new Error("Invalid authCode!") unless validCodeMemory[code]?
    sessionInfo = validCodeMemory[code]
    delete validCodeMemory[code]

    session.putInfo(code, sessionInfo)
    return true

generateNewAuthCode = (oldCode, req) ->
    log "generateNewAuthCode"
    olog {oldCode}
    if validCodeMemory[oldCode]?
        log "oldCode still available in validCodeMemory!"
        delete validCodeMemory[oldCode]
        return
    try
        sessionInfo = session.getInfo(oldCode)
        newCode = "..."
        olog {newCode}
        ## TODO generae real next Code
        validCodeMemory[newCode] = sessionInfo
        ## TODO letForget
    catch err then log err.stack
    return

#endregion

############################################################
#region exposed Functions
authmodule.authenticateRequest = (req, res, next) ->
    # log "authmodule.authenticateRequest"
    try
        code = req.body.authCode
        if specialAuth[req.path]? 
            if specialAuth[req.path](req) then next()
            else throw new Error("Wrong Special Auth!")
        else if isValidAuthCode(code) then next()
        else throw new Error("Wrong Auth Code!")
        generateNewAuthCode(code, req)
    catch err then res.send({error: err.stack})

############################################################
authmodule.getSignedNodeId = ->
    log "authmodule.getSignedNodeId"
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

#endregion

module.exports = authmodule 