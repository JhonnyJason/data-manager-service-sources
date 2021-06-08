
startupmodule = {name: "startupmodule"}
############################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["startupmodule"]?  then console.log "[startupmodule]: " + arg
    return

############################################################
startupmodule.initialize = () ->
    log "startupmodule.initialize"
    return

############################################################
startupmodule.serviceStartup = ->
    log "startupmodule.serviceStartup"
    return

export default startupmodule