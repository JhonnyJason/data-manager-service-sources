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

configmodule.masterSecretKey = "003464606f47e65cf514c2c8f1f007d432a46fbeba616781bbff52def803e6e8"
configmodule.masterPublicKey = "7102da6282ec316974e7ea6ad7d24bd077f70a969ffe865c8b99b12b314f644c"

configmodule.secretKey = "447dd15e1d5ded3d662c26e0e61bf299ccab60b2d4bc86f1ec07e4561a09df63"
configmodule.publicKey = "dc29860abee9d5783d1689ef249f0d3aa18bda443a524ae610e3c3f71c6b5bca"

configmodule.secretManagerURL = "https://secrets.extensivlyon.coffee"

configmodule.timestampFrameMS = 10000

############################################################
configmodule.initialize = () ->
    log "configmodule.initialize"
    return


export default configmodule