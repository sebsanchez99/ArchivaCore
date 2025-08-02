const { Router } = require('express')
const { 
    folderListForUser, 
    createFile, 
    downloadFile, 
    deleteAllFiles, 
    deleteCompany, 
    deleteFiles, 
    createFolder
} = require('../../controllers/app/folder.controllers')

const router = Router()

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/ListFoldersForUser
 * @description Obtiene la lista de todos los archivos
 */
router.get('/ListFoldersForUser', folderListForUser)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/createFile
 * @description Obtiene la lista de todos los archivos
 */
router.post('/createFile', createFile)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/downloadFile
 * @description Obtiene la lista de todos los archivos
 */
router.get('/downloadFile', downloadFile)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/deleteAllFiles
 * @description Obtiene la lista de todos los archivos
 */
router.delete('/deleteAllFiles', deleteAllFiles)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/deleteCompany
 * @description Obtiene la lista de todos los archivos
 */
router.delete('/deleteCompany', deleteCompany)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/deleteFiles
 * @description Obtiene la lista de todos los archivos
 */
router.delete('/deleteFiles', deleteFiles)

router.post('/createFolder', createFolder)

module.exports = router