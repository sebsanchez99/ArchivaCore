const path = require('path');
const SupabaseClient = require('../../clients/supabase.client');
const ResponseUtil = require('../../utils/response.util');
const { buildBucketName, builderStructure, copyFilesFoldersRecursively } = require('../../utils/supabase.util');

/**
 * @class Helper para la gestión de carpetas en Supabase.
 */
class FolderHelper {
  
  /**
   * Lista el contenido (carpetas y archivos) para un usuario.
   * @param {string} companyName Nombre de la empresa.
   */
  async folderListForUser(companyName) {
    const bucketName = buildBucketName(companyName);
    const structure = await builderStructure(bucketName, '');

    if (!structure) {
      return ResponseUtil.fail(
        'No se pudo listar el contenido de las carpetas del usuario'
      );
    }
    return ResponseUtil.success('La operación se realizó con éxito', {
      carpetas: structure.folders,
      archivos: structure.files,
    });
  }

  /**
   * Crea una nueva carpeta en una ruta específica.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} routeFolder Ruta de la carpeta padre.
   * @param {string} folderName Nombre de la nueva carpeta.
   */
  async createFolder(companyName, routeFolder, folderName) {
    if (routeFolder === '/') routeFolder = ''
    const folderNameToLower = folderName.toLowerCase();
    const bucketName = buildBucketName(companyName);
    const folderPath = path.posix.join(routeFolder, folderNameToLower, 'placeholder.txt');
    
    const { data, error } = await SupabaseClient.upload(bucketName, folderPath, Buffer.from(''), {
      contentType: 'text/plain',
    });

    if (error) {
      if (error.message === 'The resource already exists') {
        return ResponseUtil.fail('El nombre de la carpeta ya existe. Escoja otro.');
      }
      return ResponseUtil.fail('Error al crear la subcarpeta en Supabase', error);
    }

    return ResponseUtil.success('Carpeta creada exitosamente');
  }

  /**
   * Lista todas las rutas de carpetas de manera recursiva.
   * @param {string} companyName Nombre de la empresa.
   */
  async listAllRoutes(companyName) {
    try {
      const bucketName = buildBucketName(companyName);
      const { folders } = await builderStructure(bucketName, "");

      const paths = [];
      paths.push({ rutaCarpeta: '/' })
      this.#collectPathsRecursively(folders, paths);

      return ResponseUtil.success('Rutas listadas correctamente', paths);
    } catch (error) {
      return ResponseUtil.fail('Error al listar las carpetas', error);
    }
  }

  async updateFolder(companyName, folderName, currentRoute, newRoute) {
    try {
      const bucketName = buildBucketName(companyName)
      const normalizedRoute = newRoute === "/" ? "" : newRoute
      const finalRoute = newRoute === ""
        ? path.posix.join(path.posix.dirname(currentRoute), folderName)
        : path.posix.join(normalizedRoute, folderName)
      const { folders, files } = await builderStructure(bucketName, currentRoute, '', false)
      await copyFilesFoldersRecursively(bucketName, folders, files, finalRoute)
      return ResponseUtil.success('Carpeta actualizada exitosamente')
    } catch (error) {
      return ResponseUtil.fail('Error al actualizar la carpeta', error);
    }
  }

  /**
   * Función privada recursiva para recorrer todas las subcarpetas.
   * @param {Array} folders Lista de carpetas.
   * @param {Array} paths Acumulador de rutas.
   */
  #collectPathsRecursively(folders, paths) {
    if (!Array.isArray(folders)) return;

    for (const folder of folders) {
      paths.push({ rutaCarpeta: folder.rutaCarpeta });
      if (folder.subCarpeta && folder.subCarpeta.length > 0) {
        this.#collectPathsRecursively(folder.subCarpeta, paths);
      }
    }
  }
}

module.exports = new FolderHelper();