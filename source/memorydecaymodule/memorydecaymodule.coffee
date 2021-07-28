memorydecaymodule = {name: "memorydecaymodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["memorydecaymodule"]?  then console.log "[memorydecaymodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
defaultDecayMS = 0

#############################################################
allMemoryObjects = []
nextMemId = 0

############################################################
memorydecaymodule.initialize = ->
    log "memorydecaymodule.initialize"
    c = allModules.configmodule
    if c.memoryDefaultDecayMS?  then defaultDecayMS = c.memoryDefaultDecayMS
    return

############################################################
memorydecaymodule.createMemoryObjectFor = (obj) ->
    # log "memorydecaymodule.createMemoryObjectFor"
    Object.defineProperty(
        obj, 
        "__memoryid", 
        {
            value: nextMemId++,
            enumerable: false,
            writable: false
        }
    )
    allMemoryObjects[obj.__memoryid] = {}
    
    # olog allMemoryObjects
    
    return

############################################################
memorydecaymodule.letForget = (key, obj, ms) ->
    # log "memorydecaymodule.letForget"
    throw new Error("obj was no memoryObject!") unless obj.__memoryid?
    # log "memId: "+obj.__memoryid
    
    memObj = allMemoryObjects[obj.__memoryid]

    if ms? then decayMS = ms
    else decayMS = defaultDecayMS

    forget = -> 
        delete obj[key]
        delete memObj[key]
        return


    timeoutId = memObj[key]
    if timeoutId? then clearTimeout(timeoutId)
    timeoutId = setTimeout(forget, decayMS)
    memObj[key] = timeoutId
    return

module.exports = memorydecaymodule