const path = require('path');
const poolNewClient = require('../libs/supaBase'); // Se necesita para #builderStructure

const buildBucketName = (companyName) => {
  return companyName.toLowerCase().replace(/\s+/g, '');
};

const builderStructure = async (bucket, currentPath) => {
  const { data, error } = await poolNewClient.from(bucket).list(currentPath, {
    limit: 1000,
    offset: 0,
  });

  if (error) {
    return null;
  }

  const folders = [];
  const files = [];

  await Promise.all(
    data.map(async (item) => {
      if (item.name === 'placeholder.txt' || item.name === '.emptyFolderPlaceholder' || item.name === 'reciclaje') return;
      const isFolder = item.metadata === null;
      const pathName = `${currentPath}/${item.name}`;
      if (isFolder) {
        const newPath = path.posix.join(currentPath, item.name);
        const structure = await builderStructure(bucket, newPath); 
        if (structure) {
          folders.push({
            nombreCarpeta: item.name,
            rutaCarpeta: pathName,
            archivos: structure.files,
            subCarpeta: structure.folders,
          });
        }
      } else {
        files.push({
          nombreArchivo: item.name,
          rutaArchivo: pathName,
          tamanoMB: (item.metadata.size / (1024 * 1024)).toFixed(2),
          fecha: item.updated_at || '',
          tipo: path.extname(item.name).substring(1),
        });
      }
    })
  );
  return { folders, files };
};

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
};