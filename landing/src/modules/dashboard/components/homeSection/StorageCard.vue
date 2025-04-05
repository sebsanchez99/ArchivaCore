<template>
    <div class="bg-primary-100 rounded-lg shadow-sm p-5">
      <h2 class="font-bold text-lg text-primary-700">Almacenamiento</h2>
      <p class="text-sm text-primary-600">Espacio consumido</p>
      <div class="mt-2 text-sm font-semibold text-primary-600">
        1.5 GB de 5 GB consumidos <span class="float-right">30%</span>
      </div>
      <progress class="progress progress-primary w-full mt-1" value="30" max="100"></progress>
      <div class="mt-4 flex justify-between text-center text-sm">
        <div>
          <div class="font-bold text-primary-700">850 MB</div>
          <div class="text-gray-500">Documentos</div>
        </div>
        <div>
          <div class="font-bold text-primary-700">450 MB</div>
          <div class="text-gray-500">Imágenes</div>
        </div>
        <div>
          <div class="font-bold text-primary-700">200 MB</div>
          <div class="text-gray-500">Otros</div>
        </div>
      </div>
    </div>
  </template>
  