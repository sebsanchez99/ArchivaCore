/**
 * @namespace Controladores
 * @description Controladores de la API
 */
const SupaBaseHelper = require('../../helpers/supabase.helper ')
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
        const { companyName, fullname } = req.user
        const fileContent = req.file
        const { folderRoute } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.createFile(companyName, folderRoute, fileContent, fullname)
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
        const { companyName } = req.user 
        const { fileRoute } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.downloadFile(companyName, fileRoute)
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


const updateFile = async (req, res) => {
    try {
        const { companyName } = req.user
        const { fileName, currentRoute, newRoute } = req.body
        const supaBaseHelper = new SupaBaseHelper();
        const result = await supaBaseHelper.updateFile(companyName, fileName, currentRoute, newRoute)
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error interno al mover el archivo al reciclaje.', error.message))
    }   
}

const moveFileToRecycle = async (req, res) => {
    try {
        const {companyName } = req.user
        const { filePath } = req.body       
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.moveFileToRecycle(companyName, filePath)
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error interno al mover el archivo al reciclaje.', error.message))
    }
}

const restoreFileFromRecycle = async (req, res) => {
    try {
        const { companyName } = req.user
        const { filePath } = req.body
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.restoreFileFromRecycle(companyName,filePath)
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error interno al restaurar el archivo.', error.message))
    }
}

const listRecycleFolder = async (req, res) => {
    try {
        const { companyName } = req.user
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.listRecycleFolder(companyName)
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error al listar el contenido de la papelera.', error.message))
    }
}

const deleteFileFromRecycle = async (req, res) => {
  try {
    const { companyName} = req.user
    const { fileRoute } = req.body
    const supaBaseHelper = new SupaBaseHelper()
    const result = await supaBaseHelper.deleteFileFromRecycle( companyName, fileRoute )
    res.json(result)
  } catch (error) {
    return res.status(500).json(ResponseUtil.fail('Error interno al eliminar el archivo de reciclaje.', error.message))
  }
}

const listAllRoutes = async (req, res) => {
    try {
        const { companyName } = req.user
        const supaBaseHelper = new SupaBaseHelper()
        const result = await supaBaseHelper.listAllRoutes( companyName )
        res.json(result)
    } catch (error) {
        return res.status(500).json(ResponseUtil.fail('Error interno al listar los archivos.', error.message))

    }
}






module.exports = {
    folderListForUser,
    createFile,
    downloadFile,
    deleteAllFiles,
    deleteFiles,
    createFolder,
    moveFileToRecycle,
    restoreFileFromRecycle,
    listRecycleFolder,
    deleteFileFromRecycle,
    listAllRoutes,
    updateFile
}

