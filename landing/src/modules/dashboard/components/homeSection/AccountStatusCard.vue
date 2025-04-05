<template>
    <div class="bg-primary-200 rounded-lg shadow p-5">
      <h2 class="font-bold text-lg text-primary-700">Estado de la cuenta</h2>
      <p class="text-sm text-primary-600">Infomación de la suscripción</p>
      <div class="mt-4 space-y-2 text-sm text-primary-600">
        <div class="flex justify-between">
          <span>Plan actual:</span>
          <span class="badge badge-outline font-semibold border border-primary-500">DEMO</span>
        </div>
        <div class="flex justify-between">
          <span>Fecha de expiración:</span>
          <span class="font-semibold">12/04/2025</span>
        </div>
        <div class="flex justify-between">
          <span>Usuarios:</span>
          <span class="font-semibold">1 de 3</span>
        </div>
      </div>
      <button class="btn bg-primary-500 border-none btn-block mt-4 hover:bg-primary-400">
        Actualizar a plan completo
      </button>
    </div>
  </template>
  