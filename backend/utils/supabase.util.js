const path = require('path');
const poolNewClient = require('../libs/supaBase'); // Se necesita para #builderStructure
const ResponseUtil = require('./response.util');
const SupabaseClient = require('../clients/supabase.client');

// Mueve de forma recursiva todos los archivos y subcarpetas
const copyFilesFoldersRecursively = async (
  bucketName,
  folders,
  files,
  recyclePath,
  currentPath = ''
) => {
  for (const file of files) {
    const filePath = file.rutaArchivo;
    const fullRecyclePath =  currentPath === '' ? `${recyclePath}/${file.nombreArchivo}` : `${recyclePath}/${currentPath}/${file.nombreArchivo}`;
    await SupabaseClient.move(bucketName, filePath, fullRecyclePath);
  }

  for (const folder of folders) {
    const newPath = currentPath === '' ? folder.nombreCarpeta : `${currentPath}/${folder.nombreCarpeta}`;
    const subFolders = folder.subCarpeta || [];
    const filesInFolder = folder.archivos || [];
    await copyFilesFoldersRecursively(
      bucketName,
      subFolders,
      filesInFolder,
      recyclePath,
      newPath
    );
  }
};

const buildBucketName = (companyName) => {
  return companyName.toLowerCase().replace(/\s+/g, '');
};

const builderStructure = async (bucket, currentPath, basePathToOmit = '', omitHiddenFile = true) => {
  const { data, error } = await poolNewClient.from(bucket).list(currentPath, {
    limit: 1000,
    offset: 0,
  });  

  if (error) {
    console.error('List error:', error);
    return null;
  }

  if (!data || data.length === 0) {
    return { folders: [], files: [] };
  }

  const folders = [];
  const files = [];
  const basePrefix = basePathToOmit ? `${basePathToOmit}/` : '';

  const promises = data.map(async (item) => {
    if ((item.name === 'placeholder.txt' || item.name === '.emptyFolderPlaceholder') && omitHiddenFile) {
      return;
    }

    const isFolder = item.metadata === null;
    const pathName = currentPath ? `${currentPath}/${item.name}` : item.name;

    if (isFolder) {
      const structure = await builderStructure(bucket, pathName, basePathToOmit);
      if (structure) {
        folders.push({
          nombreCarpeta: item.name,
          rutaCarpeta: pathName.replace(new RegExp(`^${basePrefix}`), ''),
          archivos: structure.files,
          subCarpeta: structure.folders,
        });
      }
    } else {
      const { data: fileInfo, error: fileError } = await poolNewClient.from(bucket).info(pathName);

      if (fileError) {
        console.error(`Error getting file info for ${pathName}:`, fileError);
        return;
      }

      const author = fileInfo?.metadata?.author || 'Desconocido';
      const fileExtension = path.extname(item.name).substring(1);

      files.push({
        nombreArchivo: item.name,
        rutaArchivo: pathName.replace(new RegExp(`^${basePrefix}`), ''),
        tamanoMB: (item.metadata?.size / (1024 * 1024)).toFixed(2),
        fechaCreacion: item.created_at,
        fecha: item.updated_at || '',
        autor: author,
        tipo: fileExtension,
      });
    }
  });

  await Promise.all(promises);

  return { folders, files };
}

const sumFileSizesByCategory = ({ files = [], folders = [] }, categoryTotals = {}) => {
  for (const file of files) {
    const category = categorizeFile(file.tipo.toLowerCase());
    const sizeMB = parseFloat(file.tamanoMB || 0);
    categoryTotals[category] = (categoryTotals[category] || 0) + sizeMB;
  }

  for (const folder of folders) {
    sumFileSizesByCategory(
      { files: folder.archivos, folders: folder.subCarpeta },
      categoryTotals
    );
  }
  return categoryTotals;
};

const categorizeFile = (extension) => {
  const images = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'webp'];
  const documents = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'rtf'];
  const videos = ['mp4', 'mov', 'avi', 'mkv', 'webm', 'flv'];

  if (images.includes(extension)) return 'imágenes';
  if (documents.includes(extension)) return 'documentos';
  if (videos.includes(extension)) return 'videos';
  return 'otros';
};

const countFilesAndFolders = (folder) => {
  let fileCount = folder.archivos ? folder.archivos.length : 0;
  let subFolderCount = folder.subCarpeta ? folder.subCarpeta.length : 0;

  if (folder.subCarpeta && folder.subCarpeta.length > 0) {
    for (const sub of folder.subCarpeta) {
      const { fileCount: subFiles, subFolderCount: subFolders } = countFilesAndFolders(sub);
      fileCount += subFiles;
      subFolderCount += subFolders;
    }
  }
  return { fileCount, subFolderCount };
};

const getOnlyFile = (folder) => {
  if (folder.archivos && folder.archivos.length === 1) {
    return folder.archivos[0];
  }
  if (folder.subCarpeta && folder.subCarpeta.length === 1) {
    return getOnlyFile(folder.subCarpeta[0]);
  }
  return null;
};

// Exportamos todas las funciones para que puedan ser importadas
module.exports = {
  buildBucketName,
  builderStructure,
  sumFileSizesByCategory,
  categorizeFile,
  countFilesAndFolders,
  getOnlyFile,
  copyFilesFoldersRecursively,
};