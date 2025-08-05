const { Router } = require('express')
const { 
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
 * @description Crea Archivo
 */
router.post('/createFile', createFile)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/downloadFile
 * @description descarga archivo
 */
router.get('/downloadFile', downloadFile)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/deleteAllFiles
 * @description Elimina todos los archivos en una carpeta
 */
router.delete('/deleteAllFiles', deleteAllFiles)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/deleteCompany
 * @description Elimina Bucket de compañia
 */
router.delete('/deleteCompany', deleteCompany)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/deleteFiles
 * @description Elimina todos los archivos de carpeta
 */
router.delete('/deleteFiles', deleteFiles)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/createFolder
 * @description Crea la carpeta en el path seleccionado
 */
router.post('/createFolder', createFolder)

router.put('/moveToRecycle', moveFileToRecycle)

router.put('/restoreFromRecycle', restoreFileFromRecycle)

router.get('/listRecicle', listRecycleFolder)

module.exports = router