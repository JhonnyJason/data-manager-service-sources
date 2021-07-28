sessionmodule = {name: "sessionmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["sessionmodule"]?  then console.log "[sessionmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
decay = null

############################################################
decayMS = 0
sessionMemory = {}

############################################################
sessionmodule.initialize = ->
    log "sessionmodule.initialize"
    decay = allModules.memorydecaymodule
    c = allModules.configmodule
    
    if c.sessionDecayMS? then decayMS = sessionDecayMS
    
    decay.createMemoryObjectFor(sessionMemory)
    return

############################################################
sessionmodule.putInfo = (code, info) ->
    log "sessionmodule.putInfo"
    sessionMemory[code] = info
    decay.letForget(code, sessionMemory, decayMS)
    return

sessionmodule.getInfo = (code) ->
    log "sessionmodule.getInfo"
    throw new Error("No session available!") unless sessionMemory[code]?
    return sessionMemory[code]


module.exports = sessionmodule