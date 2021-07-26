sciroutes = {}

import h from "./scihandlers"

############################################################
#region authenticationroutes.coffee
############################################################
sciroutes.addClientToServe = (req, res) ->
    try
        response = await h.addClientToServe(req.body.clientPublicKey, req.body.timestamp, req.body.signature)
        res.send(response)
    catch err then res.send({error: err.stack})
    return

############################################################
sciroutes.getNodeId = (req, res) ->
    try
        response = await h.getNodeId(req.body.publicKey, req.body.timestamp, req.body.signature)
        res.send(response)
    catch err then res.send({error: err.stack})
    return

############################################################
sciroutes.startSession = (req, res) ->
    try
        response = await h.startSession(req.body.publicKey, req.body.timestamp, req.body.signature)
        res.send(response)
    catch err then res.send({error: err.stack})
    return


#endregion

############################################################
#region datamanagementroutes.coffee
############################################################
sciroutes.storeFile = (req, res) ->
    try
        response = await h.storeFile(req.body.authCode, req.body.publicKey, req.body.fileName, req.body.fileContent)
        res.send(response)
    catch err then res.send({error: err.stack})
    return

############################################################
sciroutes.updateFile = (req, res) ->
    try
        response = await h.updateFile(req.body.authCode, req.body.publicKey, req.body.fileName, req.body.fileContent)
        res.send(response)
    catch err then res.send({error: err.stack})
    return

############################################################
sciroutes.storeRestrictedFile = (req, res) ->
    try
        response = await h.storeRestrictedFile(req.body.authCode, req.body.publicKey, req.body.fileName, req.body.fileContent, req.body.keyNames)
        res.send(response)
    catch err then res.send({error: err.stack})
    return

############################################################
sciroutes.updateRestriction = (req, res) ->
    try
        response = await h.updateRestriction(req.body.authCode, req.body.publicKey, req.body.fileName, req.body.keyNames, req.body.mode)
        res.send(response)
    catch err then res.send({error: err.stack})
    return


#endregion



export default sciroutes