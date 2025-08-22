const SupabaseClient = require('../../clients/supabase.client');
const ResponseUtil = require('../../utils/response.util');
const { buildBucketName } = require('../../utils/supabase.util');

/**
 * @class Helper para la gestión de buckets de Supabase.
 */
class BucketHelper {
  
  /**
   * Crea el bucket de la empresa en Supabase.
   * @param {string} companyName Nombre de la empresa.
   */
  async createCompanyBucket(companyName) {
    const bucketName = buildBucketName(companyName);
    const { _, error } = await SupabaseClient.createBucket(bucketName, { public: false });
    
    if (error) {
      // Retornar un error de Supabase si falla la creación del bucket
      return ResponseUtil.fail('Error al crear el bucket de la empresa', error);
    }
    
    // Una vez que el bucket se crea, creamos la carpeta de reciclaje.
    // Esta lógica podría ir aquí si la consideras parte del proceso de creación del bucket.
    const recycleFolderResult = await this.#createRecicleFolder(bucketName);
    if (!recycleFolderResult) {
      return ResponseUtil.fail('Bucket creado, pero falló la creación de la carpeta de reciclaje.');
    }

    return ResponseUtil.success('Bucket y carpeta de reciclaje creados exitosamente');
  }

  /**
   * Elimina un bucket de la empresa en Supabase.
   * @param {string} companyName Nombre de la empresa.
   */
  async deleteCompany(companyName) {
    const bucketName = buildBucketName(companyName);
    const { data, error } = await SupabaseClient.deleteBucket(bucketName);
    
    if (error) {
      return ResponseUtil.fail('Error al eliminar el bucket de la empresa', error);
    }
    
    return ResponseUtil.success('Bucket eliminado exitosamente', data);
  }

  /**
   * Elimina todos los archivos dentro de un bucket.
   * @param {string} companyName Nombre de la empresa.
   */
  async deleteAllFiles(companyName) {
    const bucketName = buildBucketName(companyName);
    const { data, error } = await SupabaseClient.emptyBucket(bucketName);

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error);
    }
    return ResponseUtil.success('La operación se realizó con éxito', data);
  }

  /**
   * Método privado para crear la carpeta de reciclaje.
   * @param {string} bucketName Nombre del bucket.
   */
  async #createRecicleFolder(bucketName) {
    const folderPath = 'reciclaje/placeholder.txt';
    const { _, error } = await SupabaseClient.upload(bucketName, folderPath, Buffer.from(''), { contentType: 'Text/plain' });
    
    if (error) return false;
    return true;
  }
}

module.exports = new BucketHelper();