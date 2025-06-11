const { Router } = require('express')
const { listCompany, fileList, fileListForUser, folderListForUser, folderListFiles, createFile, downloadFile, deleteAllFiles, deleteCompany, deleteFiles, createSubFolder} = require('../../controllers/app/folder.controllers')

const router = Router()


/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/listCompanyFolders
 * @description Obtiene la lista de todos los archivos
 */
router.get('/listCompany', listCompany)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/listFiles
 * @description Obtiene la lista de todos los archivos
 */
router.get('/listFiles', fileList)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/listFilesForUser
 * @description Obtiene la lista de todos los archivos
 */
router.get('/listFilesForUser', fileListForUser )

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/ListFoldersForUser
 * @description Obtiene la lista de todos los archivos
 */
router.get('/ListFoldersForUser', folderListForUser)

/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/folderList
 * @description Obtiene la lista de todos los archivos
 */
router.get('/folderList', folderListFiles)

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

router.post('/createSubFolder', createSubFolder)

module.exports = router