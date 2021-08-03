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
secUtl = require("secret-manager-crypto-utils")
clientFactory = require("secret-manager-client")

############################################################
cfg = null
session = null
decay = null

############################################################
specialAuth = null
validCodeMemory = {}
tMS = 20000

knownClients = null
client = null

############################################################
authmodule.initialize = ->
    log "authmodule.initialize"

    cfg = allModules.configmodule
    session = allModules.sessionmodule
    decay = allModules.memorydecaymodule

    tMS = cfg.timestampFrameMS
    knownClients = {}
    client = await clientFactory.createClient(cfg.secretKey, cfg.publicKey, cfg.secretManagerURL)
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
assertValidTimestamp = (timestamp) ->
    now = Date.now()
    now_rounded = now - (now % tMS)

    if timestamp != now_rounded then now_rounded -= tMS
    else return
    if timestamp != now_rounded then now_rounded += 2 * tMS
    else return
    if timestamp != now_rounded then throw new Error("Invalid Timestamp!")
    else return
    return

isMasterSignature = (req) ->
    log "isMasterSignature"
    data = req.body
    route = req.path
    
    idHex = cfg.masterPublicKey
    
    olog data
    olog {route}

    assertValidTimestamp(data.timestamp)
    
    sigHex = data.signature
    if !sigHex then throw new Error("No Signature!")
    delete data.signature
    content = route+JSON.stringify(data)

    try
        verified = await secUtl.verify(sigHex, idHex, content)
        if !verified then throw new Error("Invalid Signature!")
        return true
    catch err then throw new Error("Error on Verify! " + err)
    return false    

isKnownClientSignature = (req) ->
    log "isKnownClientSignature"
    data = req.body
    route = req.path
    
    idHex = data.publicKey
    throw new Error("Client unknown!") unless knownClients[idHex]
    
    olog data
    olog {route}

    assertValidTimestamp(data.timestamp)
    
    sigHex = data.signature
    if !sigHex then throw new Error("No Signature!")
    delete data.signature
    content = route+JSON.stringify(data)

    try
        verified = await secUtl.verify(sigHex, idHex, content)
        if !verified then throw new Error("Invalid Signature!")
        return true
    catch err then throw new Error("Error on Verify! " + err)
    return false

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
            authorized = await specialAuth[req.path](req)
            if authorized then next()
            else throw new Error("Wrong Special Auth!")
            return
        else if isValidAuthCode(code) then next()
        else throw new Error("Wrong Auth Code!")
        generateNewAuthCode(code, req)
    catch err then res.send({error: err.stack})

############################################################
authmodule.getSignedNodeId = ->
    log "authmodule.getSignedNodeId"
    publicKey = cfg.publicKey
    timestamp = Date.now()
    timestamp = timestamp - (timestamp % tMS)
    content = JSON.stringify({publicKey, timestamp})
    signature = await secUtl.createSignature(content, cfg.secretKey)
    result = { publicKey, timestamp, signature }
    return result

############################################################
authmodule.addClient = (publicKey) ->
    log "authmodule.addClient"
    response = await client.startAcceptingSecretsFrom(publicKey)
    olog response
    throw new Error("Could not add Client!") unless response.ok
    knownClients[publicKey] = true
    return

############################################################
authmodule.startSession = (publicKey) ->
    log "authmodule.startSession"
    sessionSeed = await secUtl.createRandomLengthSalt()
    response = await client.shareSecretTo(publicKey, "sessionSeed", sessionSeed)
    olog response
    clientSeed = await client.getSecretFrom("sessionSeed", publicKey)
    
    seed = clientSeed + sessionSeed
    authCode = await secUtl.sha256Hex(seed)
    olog { authCode }

    sessionInfo = {publicKey}

    validCodeMemory[authCode] = sessionInfo
    decay.letForget(authCode, validCodeMemory, decayMS)
    return

#endregion

module.exports = authmodule 