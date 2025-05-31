<template>
    <div class="card bg-white shadow rounded border-primary-100 flex flex-col ">
        <div class="p-4 bg-primary-100">
            <h2 class="text-xl font-semibold text-text-400">Información de la cuenta</h2>
            <p class="text-sm text-text-300">Actualice la información de su cuenta</p>
        </div>
        <div class="p-6">
            <div class="mb-4">
                <label class="label text-sm">
                    Nombre de la empresa
                </label>
                <input type="text" class="input w-full bg-white border border-primary-500" v-model="companyName" />
            </div>
            <div>
                <label class="label text-sm">
                    Correo electrónico
                </label>
                <input type="text" class="input w-full bg-white border border-primary-500" v-model="email" />
            </div>
        </div>
        <div class="p-5">
            <button class="btn btn-block bg-primary-500 border-none hover:bg-primary-600 text-white">Actualizar
                información</button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const companyName = ref('Empresa Demo S.A.')
const email = ref('usuario@empresa.com')
</script>