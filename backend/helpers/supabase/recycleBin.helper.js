const SupabaseClient = require('../../clients/supabase.client.js');
const ResponseUtil = require('../../utils/response.util.js');
const { buildBucketName,
  builderStructure,
  copyFilesFoldersRecursively,
} = require('../../utils/supabase.util.js');

/**
 * @class Helper para la gestión de la papelera de reciclaje en Supabase.
 */
class RecycleBinHelper {

  /**
   * Mueve un archivo a la carpeta de reciclaje.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} filePath Ruta del archivo a mover.
   */
  async moveFileToRecycle(companyName, filePath) {
    try {
      const bucketName = buildBucketName(companyName);
      const fullRecyclePath = `reciclaje/${filePath}`;
      const { data: copyData, error: copyError } = await SupabaseClient.copy(bucketName, filePath, fullRecyclePath);
      if (copyError) {
        return ResponseUtil.fail('Error al copiar el archivo a reciclaje', copyError.message);
      }
      const { error: deleteError } = await SupabaseClient.remove(bucketName, [filePath]);
      if (deleteError) {
        return ResponseUtil.fail('Archivo copiado pero no eliminado del origen', deleteError.message);
      }
      return ResponseUtil.success('Archivo movido correctamente a reciclaje', copyData);
    } catch (err) {
      return ResponseUtil.fail('Error inesperado al mover archivo a reciclaje', err.message);
    }
  }

  /**
   * Restaura un archivo desde la carpeta de reciclaje a su ubicación original.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} filePath Ruta del archivo a restaurar.
   */
  async restoreFileFromRecycle(companyName, filePath) {
    try {
      const bucketName = buildBucketName(companyName);
      const recyclePath = `reciclaje/${filePath}`;
      const { data: copyData, error: copyError } = await SupabaseClient.copy(bucketName, recyclePath, filePath);
      if (copyError) {
        return ResponseUtil.fail('Error al restaurar el archivo desde reciclaje', copyError.message);
      }
      const { error: deleteError } = await SupabaseClient.remove(bucketName, [recyclePath]);
      if (deleteError) {
        return ResponseUtil.fail('Archivo restaurado pero no eliminado de reciclaje', deleteError.message);
      }
      return ResponseUtil.success('Archivo restaurado correctamente', copyData);
    } catch (err) {
      return ResponseUtil.fail('Error inesperado al restaurar archivo', err.message);
    }
  }

  /**
   * Lista el contenido de la carpeta de reciclaje.
   * @param {string} companyName Nombre de la empresa.
   */
  async listRecycleFolder(companyName) {
    try {
      const bucketName = buildBucketName(companyName);
      const structure = await builderStructure(bucketName, 'reciclaje', 'reciclaje', false);
      if (!structure) {
        return ResponseUtil.success('No hay elementos en reciclaje', { archivos: [], carpetas: [] });
      }
      const archivos = [];
      const carpetas = [];
      if (structure.files && structure.files.length > 0) {
        const rootFiles = structure.files.filter(file => file.nombreArchivo !== 'placeholder.txt');
        archivos.push(...rootFiles);
      }
      structure.folders.forEach(folder => this.#processFolderContent(folder, archivos, carpetas));
      return ResponseUtil.success('Carpeta reciclaje listada correctamente', {
        archivos,
        carpetas,
      });
    } catch (err) {
      return ResponseUtil.fail('Error inesperado al listar reciclaje', err.message);
    }
  }

  /**
   * Elimina un archivo permanentemente de la carpeta de reciclaje.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} fileRoute Ruta del archivo en la carpeta de reciclaje.
   */
  async deleteFileFromRecycle(companyName, fileRoute) {
    try {
      const bucketName = buildBucketName(companyName);
      const recyclePath = `reciclaje/${fileRoute}`;
      const { error: deleteError } = await SupabaseClient.remove(bucketName, [recyclePath]);
      if (deleteError) {
        return ResponseUtil.fail('Error al eliminar el archivo de reciclaje', deleteError.message);
      }
      return ResponseUtil.success('Archivo eliminado definitivamente de reciclaje');
    } catch (err) {
      return ResponseUtil.fail('Error inesperado al eliminar archivo de reciclaje', err.message);
    }
  }

  async deleteFolderFromRecycle(companyName, folderPath) {
    try {
      const bucketName = buildBucketName(companyName)
      const recyclePath = `reciclaje/${folderPath}`
      const { folders, files } = await builderStructure(bucketName, recyclePath, '', false) 
      await this.#deleteFolders(bucketName, folders, files, recyclePath, false)
      return ResponseUtil.success('Carpeta eliminada definitivamente de reciclaje');
    } catch (error) {
      return ResponseUtil.fail('Error inesperado al eliminar carpetas de reciclaje', error.message);
    }

  }

  async moveFolderToRecycle(companyName, folderPath) {
    try {
      const bucketName = buildBucketName(companyName)
      const { folders, files } = await builderStructure(bucketName, folderPath, '', false) 
      const folderRecyclePath = `reciclaje/${folderPath}`
      await copyFilesFoldersRecursively(bucketName, folders, files, folderRecyclePath)
      return ResponseUtil.success("Carpeta movida correctamente a reciclaje.");
    } catch (error) {
      return ResponseUtil.fail('Error al mover carpeta a reciclaje.')
    }
  }

  async restoreFolderFromRecycle(companyName, folderPath) {
    try {
      const bucketName = buildBucketName(companyName);
      const recycleFolderPath = `reciclaje/${folderPath}`;
      const { folders, files } = await builderStructure(bucketName, recycleFolderPath, '', false);
      const originPath = folderPath;
      await copyFilesFoldersRecursively(bucketName, folders, files, originPath);
      return ResponseUtil.success("Carpeta restaurada correctamente desde reciclaje.");
    } catch (error) {
      return ResponseUtil.fail("Error al restaurar carpeta desde reciclaje.");
    }
  }

  async emptyRecycleFolder(companyName) {
    const bucketName = buildBucketName(companyName);
    const recyclePath = 'reciclaje'
    const { folders, files } = await builderStructure(bucketName, recyclePath, '', false) 
    await this.#deleteFolders(bucketName, folders, files, recyclePath, true)
    return ResponseUtil.success('Se vacío la papelera de reciclaje correctamente.');
  }

  async #deleteFolders(bucketName, folders, files, recyclePath, ignoreRootPlaceholderFile, currentPath= '') {
    let filesToDelete = files;
    if (ignoreRootPlaceholderFile && currentPath === '') {
      filesToDelete = files.filter(file => file.nombreArchivo !== 'placeholder.txt');
    }
    for (const file of filesToDelete) {
      const fullRecyclePath = currentPath === '' ? `${recyclePath}/${file.nombreArchivo}` : `${recyclePath}/${currentPath}/${file.nombreArchivo}`;
      await SupabaseClient.remove(bucketName, [fullRecyclePath]);
    }
    for (const folder of folders) {
      const newPath = currentPath === '' ? folder.nombreCarpeta : `${currentPath}/${folder.nombreCarpeta}`;
      const subFolders = folder.subCarpeta || [];
      const filesInFolder = folder.archivos || [];
      await this.#deleteFolders(bucketName, subFolders, filesInFolder, recyclePath, false, newPath);
    }
  } 

  #processFolderContent(folder, files, folders) {
    const filesWithoutPlaceholder = (folder.archivos || []).filter(f => f.nombreArchivo !== 'placeholder.txt');
    const cleanFolder = {
      ...folder,
      archivos: filesWithoutPlaceholder,
      subCarpeta: []
    };
    if (folder.subCarpeta && folder.subCarpeta.length > 0) {
      for (const sub of folder.subCarpeta) {
        this.#processFolderContent(sub, files, cleanFolder.subCarpeta);
      }
    }
    const hasPlaceholder = folder.archivos.some(f => f.nombreArchivo === 'placeholder.txt');
    if (hasPlaceholder) {
      folders.push(cleanFolder);
    } else {
      if (filesWithoutPlaceholder.length > 0) {
        files.push(...filesWithoutPlaceholder);
      }
      if (cleanFolder.subCarpeta.length > 0) {
        folders.push(...cleanFolder.subCarpeta);
      }
    }
  }
}

module.exports = new RecycleBinHelper();