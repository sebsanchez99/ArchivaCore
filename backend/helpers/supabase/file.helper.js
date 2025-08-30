const path = require('path');
const SupabaseClient = require('../../clients/supabase.client');
const ResponseUtil = require('../../utils/response.util');
const { buildBucketName } = require('../../utils/supabase.util');

/**
 * @class Helper para la gestión de archivos en Supabase.
 */
class FileHelper {

  /**
   * Sube un nuevo archivo al bucket de la empresa.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} folderRoute Ruta de la carpeta de destino.
   * @param {object} fileContent Contenido del archivo.
   * @param {string} userFullname Nombre completo del usuario.
   */
  async createFile(companyName, folderRoute, fileContent, userFullname) {
    const bucketName = buildBucketName(companyName);
    if (folderRoute === '/') folderRoute = ''
    const { buffer, originalname, mimetype } = fileContent;
    const fullRoute = path.posix.join(folderRoute, originalname);
    const { data, error } = await SupabaseClient.upload(bucketName, fullRoute, buffer, {
      contentType: mimetype,
      upsert: true,
      metadata: { author: userFullname },
    });

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error);
    }
    return ResponseUtil.success('Archivo subido exitosamente');
  }

  /**
   * Descarga un archivo desde el bucket de la empresa.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} fileRoute Ruta del archivo a descargar.
   */
  async downloadFile(companyName, fileRoute) {
    const bucketName = buildBucketName(companyName);
    const { data, error } = await SupabaseClient.download(bucketName, fileRoute);

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error);
    }

    const arrayBuffer = await data.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);
    return ResponseUtil.success('La operación se realizó con éxito', {
      buffer,
      mimetype: data.type,
      fileName: path.posix.basename(fileRoute),
    });
  }

  /**
   * Elimina un archivo específico.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} fileName Nombre del archivo a eliminar.
   * @param {string} userName Nombre de usuario para la ruta.
   */
  async deleteFiles(companyName, userName, fileName) {
    const bucketName = buildBucketName(companyName);
    const filePath = path.posix.join(userName, fileName);

    const { data, error } = await SupabaseClient.remove(bucketName, [filePath]);

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error);
    }
    return ResponseUtil.success('La operación se realizó con éxito', data);
  }

  /**
   * Actualiza la ruta o el nombre de un archivo.
   * @param {string} companyName Nombre de la empresa.
   * @param {string} fileName Nombre del archivo.
   * @param {string} originalRoute Ruta original del archivo.
   * @param {string} newRoute Nueva ruta de destino.
   */
  async updateFile(companyName, fileName, originalRoute, newRoute) {
    const bucketName = buildBucketName(companyName);
    const normalizedRoute = newRoute === "/" ? "" : newRoute;

    const finalRoute = newRoute === ""
      ? path.posix.join(path.posix.dirname(originalRoute), fileName)
      : path.posix.join(normalizedRoute, fileName);

    const { data, error } = await SupabaseClient.move(bucketName, originalRoute, finalRoute);
    if (error) {
      return ResponseUtil.fail("Error al actualizar el archivo", error);
    }

    return ResponseUtil.success("Se ha actualizado el archivo correctamente.");
  }
}

module.exports = new FileHelper();