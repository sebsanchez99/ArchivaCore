// Importa las utilidades de respuesta y todos los helpers refactorizados
const BucketHelper = require('./supabase/bucket.helper');
const FileHelper = require('./supabase/file.helper');
const FolderHelper = require('./supabase/folder.helper');
const recycleBinHelper = require('./supabase/recycleBin.helper');
const RecycleBinHelper = require('./supabase/recycleBin.helper');
const StorageHelper = require('./supabase/storage.helper');

/**
 * @class Esta clase es un orquestador que expone métodos para la gestión de carpetas de usuarios.
 * Su única responsabilidad es delegar las peticiones a los helpers correspondientes.
 * @memberof Helpers
 */
class SupaBaseHelper {

  // Métodos de gestión de Buckets
  async createCompanyBucket(companyName) {
    return BucketHelper.createCompanyBucket(companyName);
  }

  async deleteCompany(companyName) {
    return BucketHelper.deleteCompany(companyName);
  }

  async deleteAllFiles(companyName) {
    return BucketHelper.deleteAllFiles(companyName);
  }

  // Métodos de gestión de Archivos
  async createFile(companyName, folderRoute, fileContent, userFullname) {
    return FileHelper.createFile(companyName, folderRoute, fileContent, userFullname);
  }

  async downloadFile(companyName, fileRoute) {
    return FileHelper.downloadFile(companyName, fileRoute);
  }

  async deleteFiles(companyName, userName, fileName) {
    return FileHelper.deleteFiles(companyName, userName, fileName);
  }

  async updateFile(companyName, fileName, originalRoute, newRoute) {
    return FileHelper.updateFile(companyName, fileName, originalRoute, newRoute);
  }

  // Métodos de gestión de Carpetas
  async folderListForUser(companyName) {
    return FolderHelper.folderListForUser(companyName);
  }

  async createFolder(companyName, routeFolder, folderName) {
    return FolderHelper.createFolder(companyName, routeFolder, folderName);
  }

  async listAllRoutes(companyName) {
    return FolderHelper.listAllRoutes(companyName);
  }

  // Métodos de la Papelera de Reciclaje
  async moveFileToRecycle(companyName, filePath) {
    return RecycleBinHelper.moveFileToRecycle(companyName, filePath);
  }

  async moveFolderToRecycle(companyName, folderPath) {
    return recycleBinHelper.moveFolderToRecycle(companyName, folderPath)
  }

  async restoreFolderFromRecycle(companyName, folderPath) {
    return recycleBinHelper.restoreFolderFromRecycle(companyName, folderPath)
  }

  async restoreFileFromRecycle(companyName, filePath) {
    return RecycleBinHelper.restoreFileFromRecycle(companyName, filePath);
  }

  async listRecycleFolder(companyName) {
    return RecycleBinHelper.listRecycleFolder(companyName);
  }

  async deleteFileFromRecycle(companyName, fileRoute) {
    return RecycleBinHelper.deleteFileFromRecycle(companyName, fileRoute);
  }

  async deleteFolderFromRecycle(companyName, folderPath) {
    return RecycleBinHelper.deleteFolderFromRecycle(companyName, folderPath);
  }

  // Métodos de Cálculo de Almacenamiento
  async calculateTotalStorage(companyName) {
    return StorageHelper.calculateTotalStorage(companyName);
  }
}

module.exports = SupaBaseHelper;