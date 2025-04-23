<template>
    <div class="bg-primary-100 rounded-lg shadow-sm p-5">
      <h2 class="font-semibold text-lg text-text-500">Almacenamiento</h2>
      <p class="text-sm text-text-500">Espacio consumido</p>
      <div class="mt-2 text-sm font-semibold text-text-400">
        1.5 GB de 5 GB consumidos <span class="float-right">30%</span>
      </div>
      <progress class="progress text-secondary-500 w-full mt-1" value="30" max="100"></progress>
      <div class="mt-4 flex justify-between text-center text-sm">
        <div>
          <div class="font-semibold text-text-700">850 MB</div>
          <div class="text-text-300">Documentos</div>
        </div>
        <div>
          <div class="font-semibold text-text-700">450 MB</div>
          <div class="text-text-300">Imágenes</div>
        </div>
        <div>
          <div class="font-semibold text-text-700">200 MB</div>
          <div class="text-text-300">Otros</div>
        </div>
      </div>
    </div>
  </template>
  