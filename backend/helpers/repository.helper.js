const pool = require('../libs/postgres');
const ResponseUtil = require('../utils/response.util');

class RepositoryHelper {
    
    async addFile(fileName, filePath, fileType, fileSize, userId, companyId) {
        const result = await pool.query('SELECT * FROM insertar_documento($1, $2, $4, $5, $6)', [fileName, filePath, fileType, fileSize, userId, companyId])
        if (result.rows.length === 0) {
            return ResponseUtil.fail('Error al agregar el archivo');
        }  
        return ResponseUtil.success('Archivo agregado exitosamente');   
    }

    async updateFile(fileName, filePath, fileType, fileSize, userId, companyId) {
        const result = await pool.query('SELECT * FROM actualizar_documento($1, $2, $4, $5, $6)', [fileName, filePath, fileType, fileSize, userId, companyId])
        if (result.rows.length === 0) {
            return ResponseUtil.fail('Error al actualizar el archivo');
        }
        return ResponseUtil.success('Archivo actualizado exitosamente');
    }

    async deteleFile(fileId) {
        const result = await pool.query('SELECT * FROM eliminar_documento($1)', [fileId])
        if (result.rows.length === 0) {
            return ResponseUtil.fail('Error al eliminar el archivo');
        }
        return ResponseUtil.success('Archivo eliminado exitosamente');
    }

    async listCompanyDocuments(companyId) {
        const result = await pool.query('SELECT * FROM listar_documentos_por_empresa($1)', [companyId])
        if (result.rows.length === 0) {
            return ResponseUtil.fail('No se encontraron documentos para la empresa');
        }
        return ResponseUtil.success('Documentos obtenidos exitosamente', result.rows);
    }
}

module.exports = RepositoryHelper