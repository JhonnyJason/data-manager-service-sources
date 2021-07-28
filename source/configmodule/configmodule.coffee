configmodule = {name: "configmodule"}
############################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["configmodule"]?  then console.log "[configmodule]: " + arg
    return


############################################################
configmodule.specialAuth = {
    "/addClientToServe": "masterSignature", 
    "/getNodeId": "knownClientSignature",
    "/startSession": "knownClientSignature"
}

configmodule.masterPubKey = ""

############################################################
configmodule.initialize = () ->
    log "configmodule.initialize"
    return


export default configmodule