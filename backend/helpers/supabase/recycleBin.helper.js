const SupabaseClient = require('../../clients/supabase.client');
const ResponseUtil = require('../../utils/response.util');
const { buildBucketName, builderStructure, countFilesAndFolders, getOnlyFile } = require('../../utils/supabase.util');

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
      // Llama a builderStructure y le dice que omita el prefijo 'reciclaje'
      const structure = await builderStructure(bucketName, 'reciclaje', 'reciclaje');

      if (!structure) {
        return ResponseUtil.success('No hay elementos en reciclaje', { archivos: [], carpetas: [] });
      }

      const archivos = [];
      const carpetas = [];

      if (structure.files.length > 0) {
        archivos.push(...structure.files);
      }

      for (const folder of structure.folders) {
        const { fileCount, subFolderCount } = countFilesAndFolders(folder);

        if (fileCount + subFolderCount > 1) {
          carpetas.push(folder);
        } else if (fileCount === 1 && subFolderCount === 0) {
          const onlyFile = getOnlyFile(folder);
          if (onlyFile) archivos.push(onlyFile);
        } else if (fileCount === 0 && subFolderCount === 1) {
          carpetas.push(folder);
        }
      }

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
}

module.exports = new RecycleBinHelper();