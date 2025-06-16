/**
 * @namespace Controladores
 * @description Controladores de la API
 */
const SupaBaseHelper = require('../../helpers/supaBase.helper')
const ResponseUtil = require('../../utils/response.util')

/**
 * @namespace FolderController
 * @memberof Controladores
 * @description Controladores de carpeta
 */

/**
 * @memberof Controladores.FolderController
 * @function listCompany
 * @description Controlador que permite listar todas las carpetas de empresas existentes en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const listCompany = async(req, res) => { 
    try {
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.listCompany()
        res.json(result)
    }catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

/**
 * @memberof Controladores.FolderController
 * @function fileList
 * @description Controlador que permite listar el bucket de  archivos de empresas existentes en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
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

/**
 * @memberof Controladores.FolderController
 * @function fileListForUser
 * @description Controlador que permite listar archivos de una  empresa existente en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
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

/**
 * @memberof Controladores.FolderController
 * @function folderListForUser
 * @description Controlador que permite listar las carpetas y subcarpetas de una  empresa existente en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const folderListForUser = async(req, res) => {
    try {
        const {companyName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.folderListForUser(companyName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

/**
 * @memberof Controladores.FolderController
 * @function folderList
 * @description Controlador que permite listar una carpeta y sus archivos de una  empresa existente en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const folderListFiles = async(req,res) => {
    try {
        const { companyName, userName, folderName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.folderListFiles(companyName, userName, folderName)
        res.json(result)
    }catch (eror){
        res.status(500).send(ResponseUtil.fail(error.message))

    }
}

/**
 * @memberof Controladores.FolderController
 * @function createFile
 * @description Controlador que permite crear un archivo en la ubicacion seleccionada de una  empresa existente en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const  createFile = async(req, res) => {
    try {
        const {companyName, userName, folderName, fileName} = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.createFile(companyName, userName, folderName, fileName)
        res.json(result)
    }catch (error){
        res.status(500).send(ResponseUtil.fail(error.message))
    }
    
}

/**
 * @memberof Controladores.FolderController
 * @function downloadFile
 * @description Controlador que permite descargar un archivo en la ubicacion seleccionada de una  empresa existente en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
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

/**
 * @memberof Controladores.FolderController
 * @function deleteAllFiles
 * @description Controlador que permite eliminar todos los archivos de una  empresa existente en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
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

/**
 * @memberof Controladores.FolderController
 * @function deleteCompany
 * @description Controlador que permite eliminar una  empresa existente en SupaBase Storage, (requiere estar vacia para poder ser eliminado)
 * @param {*} req 
 * @param {*} res 
 */
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

/**
 * @memberof Controladores.FolderController
 * @function deleteFiles
 * @description Controlador que permite eliminar un archivo en la ruta seleccionada de una empresa existenten en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
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

/**
 * @memberof Controladores.FolderController
 * @function createSubFolder
 * @description Controlador que permite crear subCarpetas en el bucket seleccionado de SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const createSubFolder = async (req, res) => {
    try {
        const { companyName, userName, folderName } = req.body;
        const supaBaseHelper = new SupaBaseHelper();
        const result = await supaBaseHelper.createSubFolder(companyName, `${userName}/${folderName}`, folderName);
        res.json(result);
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message));
    }
}

// const fileToRecicle = async (req, res) => {
//     try {
//         const { companyName}
//     }
// }
//    const { data, error } = await storageClient
//   .from(')
//   .move('old/path/to/file', 'new/path/to/file')
   
module.exports = {
    listCompany,
    fileList,
    fileListForUser,
    folderListForUser,
    folderListFiles,
    createFile,
    downloadFile,
    deleteAllFiles,
    deleteCompany,
    deleteFiles, 
    createSubFolder
}

