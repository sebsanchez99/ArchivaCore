const path = require('path')
const poolNewClient = require('../libs/supaBase')
const ResponseUtil = require('../utils/response.util')
const { log } = require('console')

/**
 * @class Esta clase contiene métodos para la gestión de carpetas de usuarios
 * @memberof Helpers
 */
class SupaBaseHelper {

  /**
   * Crea el bucket de la empresa en Supabase
   * @param { string } companyName Nombre de la empresa 
   */
  async createCompanyBucket(companyName) {
    const bucketName = this.#buildBucketName(companyName)
    const { _, error  } = await poolNewClient.createBucket(bucketName, { public: false })
    if (error) return false
    const result = await this.#createRecicleFolder(bucketName)
    return result
  }

  async folderListForUser(companyName) {
    const bucketName = this.#buildBucketName(companyName)
    const structure = await this.#builderStructure(bucketName, '', true)
    if (!structure) {
      return ResponseUtil.fail(
        'No se pudo listar el contenido de las carpetas del usuario'
      )
    }
    return ResponseUtil.success('La operación se realizó con éxito', {
      carpetas: structure.folders,
      archivos: structure.files,
    })
  }

  async createFile(companyName, userName, folderName, fileName) {
    const prefix = `/${userName}/${folderName}/${fileName}`
    const { data, error } = await poolNewClient
      .from(companyName)
      .upload(prefix)

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error)
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async downloadFile(companyName, userName, fileName) {
    const prefix = `${companyName}`
    const prefix2 = `/${userName}/${fileName}`
    const { data, error } = await poolNewClient.from(prefix).download(prefix2)

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error)
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async deleteAllFiles(companyName) {
    const bucketName = this.#buildBucketName(companyName)
    const { data, error } = await poolNewClient.emptyBucket(bucketName)

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error)
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async deleteCompany(companyName) {
    const bucketName = this.#buildBucketName(companyName)
    const { data, error } = await poolNewClient.deleteBucket(bucketName)
    if (error) {
      return ResponseUtil.fail('Error al eliminar la cuenta.', error)
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async changeBucketName(companyName) {
    const bucketName = this.#buildBucketName(companyName)
    const {  } = await poolNewClient.updateBucket(bucketName, {})
  }

  async deleteFiles(companyName, userName, fileName) {
    const prefix = `${companyName}`
    const prefix2 = `/${userName}/${fileName}`
    const { data, error } = await poolNewClient.from(prefix).remove(prefix2)

    if (error) {
      return ResponseUtil.fail('Hubo un error al conectar con Supabase', error)
    }
    return ResponseUtil.success('La operación se realizó con éxito', data)
  }

  async createFolder(companyName, routeFolder, folderName) {
    const folderNameToLower = folderName.toLowerCase()
    const bucketName = this.#buildBucketName(companyName)
    const folderPath = `${routeFolder}/${folderNameToLower}/placeholder.txt` 
    const { data, error } = await poolNewClient
      .from(bucketName)
      .upload(folderPath, Buffer.from(''), {
        contentType: 'text/plain',
      })

    if (error) {
      if (error.message === 'The resource already exists') {
        return ResponseUtil.fail('El nombre de la carpeta ya existe. Escoja otro.')
      }
      return ResponseUtil.fail('Error al crear la subcarpeta en Supabase', error)
    }

    return ResponseUtil.success('Carpeta creada exitosamente')
  }

  async calculateTotalStorage(companyName) {
    const bucketName = this.#buildBucketName(companyName)
    const structure = await this.#builderStructure(bucketName, '', true)
    
    if (!structure) {
      return ResponseUtil.fail('No se pudo calcular el almacenamiento total')
    }

    const categories = this.#sumFileSizesByCategory(structure)
    const totalMB = Object.values(categories).reduce((acc, val) => acc + val, 0)
    const totalGB = totalMB / 1024

    return ResponseUtil.success('Se realizó la operación correctamente', {
      totalMB: totalMB.toFixed(2),
      totalGB: totalGB.toFixed(2),
      categories: Object.fromEntries(
        Object.entries(categories).map(([cat, val]) => [cat, val.toFixed(2)])
      )
    })
  }

  async #builderStructure(bucket, currentPath, omitCurrentFolder = false) {
    const { data, error } = await poolNewClient.from(bucket).list(currentPath, {
      limit: 1000,
      offset: 0,
    })
    if (error) {
      return null
    }
    const folders = []
    const files = []

    await Promise.all(
      data.map(async (item) => {
        if (item.name === 'placeholder.txt' || item.name === '.emptyFolderPlaceholder' || item.name === 'reciclaje') return 
        const isFolder = item.metadata === null
        const pathName = `${currentPath}/${item.name}`
        if (isFolder) {
          if (omitCurrentFolder && item.name === path.basename(currentPath)) {
            return
          }
          const newPath = path.posix.join(currentPath, item.name)
          const structure = await this.#builderStructure(bucket, newPath)
          if (structure) {
            folders.push({
              nombreCarpeta: item.name,
              rutaCarpeta: pathName,
              archivos: structure.files,
              subCarpeta: structure.folders,
            })
          }
        } else {
          files.push({
            nombreArchivo: item.name,
            rutaArchivo: pathName,
            tamanoMB: (item.metadata.size / (1024 * 1024)).toFixed(2),
            fecha: item.updated_at || '',
            tipo: path.extname(item.name).substring(1),
          })
        }
      })
    )
    return { folders, files }
  }

  #sumFileSizesByCategory({ files = [], folders = [] }, categoryTotals = {}) {
    for (const file of files) {
      const category = this.#categorizeFile(file.tipo.toLowerCase())
      const sizeMB = parseFloat(file.tamanoMB || 0)
      categoryTotals[category] = (categoryTotals[category] || 0) + sizeMB
    }

    for (const folder of folders) {
      this.#sumFileSizesByCategory(
        { files: folder.archivos, folders: folder.subCarpeta },
        categoryTotals
      )
    }

    return categoryTotals
  }

  #categorizeFile(extension) {
    const images = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'webp']
    const documents = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'rtf']
    const videos = ['mp4', 'mov', 'avi', 'mkv', 'webm', 'flv']

    if (images.includes(extension)) return 'imágenes'
    if (documents.includes(extension)) return 'documentos'
    if (videos.includes(extension)) return 'videos'
    return 'otros'
  }

  async #createRecicleFolder(companyName) {
    const folderPath = 'reciclaje/placeholder.txt'
    const { _, error } = await poolNewClient.from(companyName).upload(folderPath, Buffer.from(''), { contentType: 'Text/plain' })
    if(error) return false
    return true
  }

  #buildBucketName(companyName) {
    return companyName.toLowerCase().replace(/\s+/g, '')
  }

  async moveFileToRecycle({ bucketId, currentPath, fileName }) {
    try {
      const fullSourcePath = `${currentPath}/${fileName}`
      const fullRecyclePath = `reciclaje/${fileName}`
     
      // Copiar archivo al destino "reciclaje"
      const { data: copyData, error: copyError } = await poolNewClient.from(bucketId)
        .copy(fullSourcePath, fullRecyclePath)

      if (copyError) {
        return ResponseUtil.fail('Error al copiar el archivo a reciclaje', copyError.message)
      }

      // Eliminar archivo original
      const { error: deleteError } = await poolNewClient.from(bucketId)
        .remove([fullSourcePath])

      if (deleteError) {
        return ResponseUtil.fail('Archivo copiado pero no eliminado del origen', deleteError.message)
      }

      return ResponseUtil.success('Archivo movido correctamente a reciclaje', copyData)
    } catch (err) {
      return ResponseUtil.fail('Error inesperado al mover archivo a reciclaje', err.message)
    }
  }

  async restoreFileFromRecycle({ bucket, originalPath, fileName }) {
    try {
      const recyclePath = `reciclaje/${fileName}`
      const targetPath = `${originalPath}/${fileName}`
      
      // Copiar desde reciclaje a ruta original
      const { data: copyData, error: copyError } = await poolNewClient.from(bucket)
        .copy(recyclePath, targetPath)

      if (copyError) {
        return ResponseUtil.fail('Error al restaurar el archivo desde reciclaje', copyError.message)
      }

      // Eliminar archivo en carpeta reciclaje
      const { error: deleteError } = await poolNewClient.from(bucket)
        .remove([recyclePath])

      if (deleteError) {
        return ResponseUtil.fail('Archivo restaurado pero no eliminado de reciclaje', deleteError.message)
      }

      return ResponseUtil.success('Archivo restaurado correctamente', copyData)
    } catch (err) {
      return ResponseUtil.fail('Error inesperado al restaurar archivo', err.message)
    }
  }

  async listRecycleFolder(bucket) {
    try {
      const { data, error } = await poolNewClient.from(bucket)
        .list('reciclaje/', { limit: 100 })

      if (error) {
        return ResponseUtil.fail('Error al listar la carpeta de reciclaje', error.message)
      }

      return ResponseUtil.success('Carpeta reciclaje listada correctamente', data)
    } catch (err) {
      return ResponseUtil.fail('Error inesperado al listar reciclaje', err.message)
    }
  }

  async deleteFileFromRecycle({ bucket, fileName }) {
  try {
    const recyclePath = `reciclaje/${fileName}`

    // Eliminar archivo de la carpeta reciclaje
    const { error: deleteError } = await poolNewClient.from(bucket)
      .remove([recyclePath])

    if (deleteError) {
      return ResponseUtil.fail('Error al eliminar el archivo de reciclaje', deleteError.message)
    }

    return ResponseUtil.success('Archivo eliminado definitivamente de reciclaje')
  } catch (err) {
    return ResponseUtil.fail('Error inesperado al eliminar archivo de reciclaje', err.message)
  }
}



}

module.exports = SupaBaseHelper

