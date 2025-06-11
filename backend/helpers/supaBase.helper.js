const path = require('path')
const poolNewClient = require("../libs/supaBase")
const ResponseUtil = require('../utils/response.util')
const { type } = require('os')


/**
 * @class Esta clase contiene métodos para la gestión de carpetas de usuarios
 * @memberof Helpers
 */
class SupaBaseHelper {

  /**
   * Método que lista todas las carpetas
   * @returns  {ResponseUtil} Resultado de la operación en formato JSON
   */
  async listCompany() {
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
  
  async folderListForUser(companyName, userName){
    const structure = await this.#builderStructure(companyName, userName, true)    
    if (!structure){
      return ResponseUtil.fail('No se pudo listar el contenido de las carpetas del usuario') 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', { 
      carpetas:structure.folders,
      archivos: structure.files
    })
    
  }

  async folderListFiles(companyName, userName, folderName){
    const structure =await this.#builderStructure(companyName, userName, folderName, true)
    if (!structure){
      return ResponseUtil.fail('No se pudo listar el contenido de las carpetas del usuario')

    }
    return ResponseUtil.success('La operación se realizó con éxito', {
      carpetas: structure.folders,
      archivos: structure.files
    })
  }

  async createFile(companyName, userName, folderName,fileName){
    const prefix = `/${userName}/${folderName}/${fileName}`
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
    const prefix = `${companyName}`
    const prefix2 = `/${userName}/${fileName}`
    const { data, error } = await poolNewClient.from(prefix).remove(prefix2)

    if (error){
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error) 
    
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async createSubFolder(companyName, userName, folderName) {
    const folderPath = `${userName}/${folderName}/placeholder.txt`; // Subimos un archivo vacío
    const { data, error } = await poolNewClient.from(companyName).upload(folderPath, Buffer.from(''), {
        contentType: 'text/plain',
    });

    if (error) {
        return ResponseUtil.fail('Error al crear la subcarpeta en Supabase', error);
    }

    return ResponseUtil.success('Subcarpeta creada exitosamente', { path: `${userName}/${folderName}/` });
}



  async #builderStructure(bucket, currentPath, omitCurrentFolder=false){
    const { data, error } = await poolNewClient.from(bucket).list(currentPath,
      {
        limit:1000,
        offset:0
      }
    )
    if (error){
      return null
    }
    const folders = []
    const files = []

    await Promise.all(data.map(async(item) =>{
      const isFolder = item.metadata === null
      if (isFolder) {
        if (omitCurrentFolder && item.name === path.basename(currentPath)){
          return
        }
        const newPath = path.posix.join(currentPath, item.name)
        const structure = await this.#builderStructure(bucket, newPath)
        if(structure){
          folders.push({
            nombreCarpeta: item.name,
            rutaCarpeta: currentPath,
            archivos: structure.files,
            subCarpeta: structure.folders,
          })
        }
      } else{
        files.push({
          nombreArchivo: item.name,
          rutaArchivo: `${currentPath}/${item.name}`,
          tamanoMB: (item.metadata.size/(1024*1024)).toFixed(2),
          fecha: item.updated_at || '',
          tipo: path.extname(item.name).substring(1)
        })
      }
    }))
    return {folders, files}  }
}
  
  


module.exports = SupaBaseHelper