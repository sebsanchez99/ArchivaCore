const poolNewClient = require('../libs/supaBase.js');

const SupabaseClient = {
  createBucket: (bucketName, options) => poolNewClient.createBucket(bucketName, options),
  deleteBucket: (bucketName) => poolNewClient.deleteBucket(bucketName),
  emptyBucket: (bucketName) => poolNewClient.emptyBucket(bucketName),
  upload: (bucket, filePath, fileBuffer, options) => poolNewClient.from(bucket).upload(filePath, fileBuffer, options),
  download: (bucket, filePath) => poolNewClient.from(bucket).download(filePath),
  list: (bucket, path, options) => poolNewClient.from(bucket).list(path, options),
  copy: (bucket, fromPath, toPath) => poolNewClient.from(bucket).copy(fromPath, toPath),
  remove: (bucket, filePaths) => poolNewClient.from(bucket).remove(filePaths),
  move: (bucket, fromPath, toPath) => poolNewClient.from(bucket).move(fromPath, toPath),
};

module.exports = SupabaseClient;