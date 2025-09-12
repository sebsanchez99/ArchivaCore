const ResponseUtil = require('../../utils/response.util.js');
const { 
  buildBucketName, 
  builderStructure, 
  sumFileSizesByCategory 
} = require('../../utils/supabase.util.js');

/**
 * @class Helper para el cálculo de almacenamiento y estadísticas del bucket.
 */
class StorageHelper {

  /**
   * Calcula el almacenamiento total y el desglose por categorías de archivos.
   * @param {string} companyName Nombre de la empresa.
   */
  async calculateTotalStorage(companyName) {
    const bucketName = buildBucketName(companyName);
    const structure = await builderStructure(bucketName, '');

    if (!structure) {
      return ResponseUtil.fail('No se pudo calcular el almacenamiento total');
    }

    const categories = sumFileSizesByCategory(structure);
    const totalMB = Object.values(categories).reduce((acc, val) => acc + val, 0);
    const totalGB = totalMB / 1024;

    return ResponseUtil.success('Se realizó la operación correctamente', {
      totalMB: totalMB.toFixed(2),
      totalGB: totalGB.toFixed(2),
      categories: Object.fromEntries(
        Object.entries(categories).map(([cat, val]) => [cat, val.toFixed(2)])
      )
    });
  }
}

module.exports = new StorageHelper();