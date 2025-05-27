/**
 * @namespace Controladores
 * @description Controladores de la API
 */
const SupaBaseHelper = require('../helpers/supaBase.helper')
const ResponseUtil = require('../utils/response.util')

/**
 * @namespace FolderController
 * @memberof Controladores
 * @description Controladores de carpeta
 */

/**
 * @memberof Controladores.FolderController
 * @function listCompanyFolders
 * @description Controlador que permite listar todas las carpetas de usuarios existentes en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const listCompanyFolders = async(req, res) => { 
    try {
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.listCompanyFolders()
        res.json(result)
    }catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}
const fileList = async(req, res) => {
    try {
        const {companyName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.fileList(companyName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const fileListForUser = async(req, res) => {
    try {
        const {companyName, userName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.fileListForUser(companyName, userName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const folderListForUser = async(req, res) => {
    try {
        const {companyName, userName, folderName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.folderListForUser(companyName, userName, folderName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const  createFile = async(req, res) => {
    try {
        const {companyName, userName, fileName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.createFile(companyName, userName, fileName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
    
}

const downloadFile = async(req, res) => {
    try {
        const {companyName, userName, fileName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.downloadFile(companyName, userName, fileName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const deleteAllFiles = async(req, res) => {
    try{
        const {companyName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.deleteAllFiles(companyName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const deleteCompany = async(req, res) => {
    try{
        const {companyName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.deleteCompany(companyName)
        res.json(result)
    }catch(error){
    res.status(500).send(ResponseUtil.fail(error.message))
    }
    
}

const deleteFiles = async(req, res) => {
    try{
        const {companyName, userName, fileName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.deleteFiles(companyName, userName, fileName)
        res.json(result)

    }catch(error){
    res.status(500).send(ResponseUtil.fail(error.message))
    }
}

   
module.exports = {
    listCompanyFolders,
    fileList,
    fileListForUser,
    folderListForUser,
    createFile,
    downloadFile,
    deleteAllFiles,
    deleteCompany,
    deleteFiles
}

