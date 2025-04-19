<template>
    <div class="bg-accent-100 rounded-lg shadow-sm p-5">
      <h2 class="font-bold text-lg text-text-500">Estado de la cuenta</h2>
      <p class="text-sm text-text-500">Infomación de la suscripción</p>
      <div class="mt-4 space-y-2 text-sm text-text-400">
        <div class="flex justify-between">
          <span>Plan actual:</span>
          <span class="badge badge-outline font-semibold border border-secondary-500 text-secondary-500">DEMO</span>
        </div>
        <div class="flex justify-between">
          <span>Fecha de expiración:</span>
          <span class="font-semibold text-secondary-500">12/04/2025</span>
        </div>
        <div class="flex justify-between">
          <span>Usuarios:</span>
          <span class="font-semibold text-secondary-500">1 de 3</span>
        </div>
      </div>
      <button class="btn bg-primary-500 border-none btn-block mt-4 hover:bg-primary-600">
        Actualizar a plan completo
      </button>
    </div>
  </template>
  