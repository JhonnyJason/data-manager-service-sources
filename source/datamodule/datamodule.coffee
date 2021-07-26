datamodule = {name: "datamodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["datamodule"]?  then console.log "[datamodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
datamodule.initialize = () ->
    log "datamodule.initialize"
    return


############################################################
#region exposedFunctions
datamodule.storeFle = (nodeId, name, content) ->
    log "datamodule.storeFle"
    return

datamodule.updateFile = (nodeId, name, content) ->
    log "datamodule.updateFile"
    return

datamodule.storeRestrictedFile = (nodeId, name, content, keys) ->
    log "datamodule.storeRestrictedFile"
    return

datamodule.updateRestriction = (nodeId, name, keys, mode) ->
    log "datamodule.updateRestriction"
    return

#endregion

module.exports = datamodule