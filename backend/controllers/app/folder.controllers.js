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
 * @function folderListForUser
 * @description Controlador que permite listar las carpetas y subcarpetas de una empresa existente en SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const folderListForUser = async (req, res) => {
    try {
        const { companyName } = req.user
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.folderListForUser(companyName)
        res.json(result)
    } catch (error) {
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
const createFile = async (req, res) => {
    try {
        const { companyName, userName, folderName, fileName } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.createFile(companyName, userName, folderName, fileName)
        res.json(result)
    } catch (error) {
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
const downloadFile = async (req, res) => {
    try {
        const { companyName, userName, fileName } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.downloadFile(companyName, userName, fileName)
        res.json(result)
    } catch (error) {
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
const deleteAllFiles = async (req, res) => {
    try {
        const { companyName } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.deleteAllFiles(companyName)
        res.json(result)
    } catch (error) {
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
const deleteCompany = async (req, res) => {
    try {
        const { companyName } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.deleteCompany(companyName)
        res.json(result)
    } catch (error) {
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
const deleteFiles = async (req, res) => {
    try {
        const { companyName, userName, fileName } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.deleteFiles(companyName, userName, fileName)
        res.json(result)

    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

/**
 * @memberof Controladores.FolderController
 * @function createFolder
 * @description Controlador que permite crear subCarpetas en el bucket seleccionado de SupaBase Storage
 * @param {*} req 
 * @param {*} res 
 */
const createFolder = async (req, res) => {
    try {
        const { companyName } = req.user
        const { folderName, routeFolder } = req.body;
        const supaBaseHelper = new SupaBaseHelper();
        const result = await supaBaseHelper.createFolder(companyName, routeFolder, folderName);
        res.json(result);
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message));
    }
}

const moveFileToRecycle = async (req, res) => {
    try {
        const { bucketId, currentPath, fileName } = req.body
        
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.moveFileToRecycle({bucketId, currentPath, fileName})
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error interno al mover el archivo al reciclaje.', error.message))
    }
}

const restoreFileFromRecycle = async (req, res) => {
    try {
        const { bucket, originalPath, fileName } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.restoreFileFromRecycle({bucket, originalPath, fileName})
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error interno al restaurar el archivo.', error.message))
    }
}

const listRecycleFolder = async (req, res) => {
    try {
        const { bucket } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.listRecycleFolder(bucket)
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error al listar el contenido de la papelera.', error.message))
    }
}



module.exports = {
    folderListForUser,
    createFile,
    downloadFile,
    deleteAllFiles,
    deleteCompany,
    deleteFiles,
    createFolder,
    moveFileToRecycle,
    restoreFileFromRecycle,
    listRecycleFolder
}

