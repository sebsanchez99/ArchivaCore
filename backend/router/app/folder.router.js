const { Router } = require('express')
const multer = require('multer')
const {
    folderListForUser, 
    createFile, 
    downloadFile, 
    deleteAllFiles, 
    deleteFiles, 
    createFolder,
    moveFileToRecycle,
    moveFolderToRecycle,
    restoreFileFromRecycle,
    restoreFolderFromRecycle,
    listRecycleFolder,
    deleteFileFromRecycle,
    deleteFolderFromRecycle,
    listAllRoutes,
    updateFile,
    updateFolder,
} = require('../../controllers/app/folder.controllers')

const router = Router()
const upload = multer({ storage: multer.memoryStorage() })

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
router.post('/createFile', upload.single('fileContent'), createFile)

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

router.put('/updateFile', updateFile)

router.put('/updateFolder', updateFolder)
/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/moveToRecycle
 * @description Mueve el archivo para a la carpeta reciclaje del bucket
 */
router.put('/moveToRecycle', moveFileToRecycle)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/moveFolderToRecycle
 * @description Mueve el archivo para a la carpeta reciclaje del bucket
 */
router.put('/moveFolderToRecycle', moveFolderToRecycle)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/restoreFromRecycle
 * @description Recupera el archivo de la carpeta reciclaje al path original
 */
router.put('/restoreFromRecycle', restoreFileFromRecycle)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/restoreFromRecycle
 * @description Recupera el archivo de la carpeta reciclaje al path original
 */
router.put('/restoreFolderFromRecycle', restoreFolderFromRecycle)


/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/listRecicle
 * @description Lista los archivos de la carpeta reciclaje del bucket
 */
router.get('/listRecicle', listRecycleFolder)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/listRecicle
 * @description Borra el archivo de la carpeta reciclaje del bucket 
 */
router.delete('/deleteFileRecycle', deleteFileFromRecycle)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/deleteFolderFromRecycle
 * @description Borra el archivo de la carpeta reciclaje del bucket 
 */
router.delete('/deleteFolderFromRecycle', deleteFolderFromRecycle)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/listAllRoutes
 * @description Lista las rutas de todas las carpetas del bucket
 */
router.get('/listAllRoutes', listAllRoutes)

module.exports = router