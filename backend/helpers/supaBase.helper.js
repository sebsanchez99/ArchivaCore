const { StorageClient } = require("@supabase/storage-js")
const poolNewClient = require("../libs/supaBase")
const ResponseUtil = require('../utils/response.util')

/**
 * @class Esta clase contiene métodos para la gestión de carpetas de usuarios
 * @memberof Helpers
 */
class SupaBaseHelper {

  /**
   * Método que lista todas las carpetas
   * @returns  {ResponseUtil} Resultado de la operación en formato JSON
   */
  async listCompanyFolders() {
    const { data, error } = await poolNewClient.listBuckets()
  
    if (error){
    return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async fileList(companyName){
    const { data, error } = await poolNewClient.getBucket(companyName)

  if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async fileListForUser(companyName, userName){
    const { data, error } = await poolNewClient.from(companyName).list(userName)
    
  if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }
  
  async folderListForUser(companyName, userName, folderName){
    const prefix = `${userName}/${folderName}`
    const { data, error } = await poolNewClient.from(companyName).list(prefix)
    
    if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
    
  }

  async createFile(companyName, userName, folderName){
    const prefix = `/${userName}/${folderName}`
    const { data, error } = await poolNewClient.from(companyName).upload(prefix)

    if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async downloadFile(companyName, userName, fileName){
    const prefix = `${companyName}`
    const prefix2 = `/${userName}/${fileName}`
    const { data, error } = await poolNewClient.from(prefix).download(prefix2)

    if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)

  }

  async deleteAllFiles(companyName){
    const { data, error } = await poolNewClient.emptyBucket(companyName)

    if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
    }

  async deleteCompany(companyName){
    const { data, error } = await poolNewClient.deleteBucket(companyName)

    if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }
  
  async deleteFiles(companyName, userName, fileName){
    const prefix = `/${companyName}`
    const prefix2 = `/${userName}/${fileName}`
    const { data, error } = await poolNewClient.from(prefix).remove(prefix2)

    if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

}
  


module.exports = SupaBaseHelper