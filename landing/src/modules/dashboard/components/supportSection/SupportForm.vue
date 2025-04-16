<template>
    <div class="bg-primary-100 p-6 rounded shadow w-full max-w-lg mx-auto h-[500px]">
        <div class="flex items-center gap-2">
            <EnvelopeIcon class="w-5 text-primary-700" />
            <h2 class="text-xl font-semibold text-primary-700 mb-1">Enviar una consulta</h2>
        </div>
        <p class="text-sm text-primary-600 mb-6">
            Nuestro equipo de soporte le responderá lo antes posible
        </p>

        <div class="form-control mb-4">
            <label class="label text-sm">
                Asunto
            </label>
            <input v-model="subject" type="text" placeholder="Ej: Problema con la aplicación"
                class="input bg-white border border-primary-500 w-full" />
        </div>

        <div class="form-control mb-4">
            <label class="label text-sm">
                Categoría
            </label>
            <select v-model="category" class="select bg-white border border-primary-500 w-full">
                <option value="" disabled selected>Seleccione una categoría</option>
                <option value="technical">Técnico</option>
                <option value="billing">Facturación</option>
                <option value="general">General</option>
            </select>
        </div>

        <div class="form-control mb-6">
            <label class="label text-sm">
                Mensaje
            </label>
            <textarea v-model="message" 
                class="textarea bg-white w-full border border-primary-500 min-h-[125px]" placeholder="Describa su consulta en detalle..."></textarea>
        </div>

        <button class="btn btn-block bg-primary-500 border-none hover:bg-primary-400">
            Enviar consulta
        </button>
    </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { EnvelopeIcon } from "@heroicons/vue/24/outline"

const subject = ref('')
const category = ref('')
const message = ref('')
</script>

<style scoped>
textarea {
    resize: none;
}
</style>