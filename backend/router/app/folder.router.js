const { Router } = require('express')
const { listCompany, fileList, fileListForUser, folderListForUser, createFile, downloadFile, deleteAllFiles, deleteCompany, deleteFiles} = require('../../controllers/app/folder.controllers')

const router = Router()


/**
 * @memberof Rutas.FolderRouter
 * @name get/api/v1/supa/listCompanyFolders
 * @description Obtiene la lista de todos los archivos
 */
router.get('/listCompany', listCompany)

router.get('/listFiles', fileList)

router.get('/listFilesForUser', fileListForUser )

router.get('/ListFoldersForUser', folderListForUser)

router.post('/createFile', createFile)

router.get('/downloadFile', downloadFile)

router.delete('/deleteAllFiles', deleteAllFiles)

router.delete('/deleteCompany', deleteCompany)

router.delete('/deleteFiles', deleteFiles)

module.exports = router