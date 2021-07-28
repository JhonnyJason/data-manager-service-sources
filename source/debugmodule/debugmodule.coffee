debugmodule = {name: "debugmodule"}

############################################################
debugmodule.initialize = () ->
    #console.log "debugmodule.initialize - nothing to do"
    return

############################################################
debugmodule.modulesToDebug = 
    unbreaker: true
    authmodule: true
    # configmodule: true
    datamodule: true
    # memorydecaymodule: true
    # sessionmodule: true
    # startupmodule: true

#region exposed variables

export default debugmodule