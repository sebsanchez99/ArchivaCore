<template>
    <section class="bg-primary-200 py-12 px-20">
        <h2 class="text-4xl font-bold text-center mb-10">Características Principales</h2>
        <div class="flex flex-col md:flex-row md:flex-wrap justify-center gap-6">
            <div class="bg-white rounded-lg  p-6 text-center shadow-sm w-full md:w-5/12 lg:w-1/4">
                <ServerStackIcon class="mx-auto mb-4 text-blue-400 w-10 h-10" />
                <h3 class="text-xl font-bold mb-2">Almacenamiento Seguro</h3>
                <p class="text-primary-600">Guarde sus documentos con la máxima seguridad y acceda a ellos desde cualquier lugar.</p>
            </div>
            <!-- Tarjeta 2 -->
            <div class="bg-white rounded-lg  p-6 text-center shadow-sm w-full md:w-5/12 lg:w-1/4">
                <FolderIcon class="mx-auto mb-4 text-blue-400 w-10 h-10" />
                <h3 class="text-xl font-semibold mb-2">Organización Inteligente</h3>
                <p class="text-gray-500">Clasifique automáticamente sus archivos con nuestro sistema de etiquetado inteligente.</p>
            </div>
            
            <!-- Tarjeta 3 -->
            <div class="bg-white rounded-lg  p-6 text-center shadow-sm w-full md:w-5/12 lg:w-1/4">
                <LockClosedIcon class="mx-auto mb-4 text-blue-400 w-10 h-10" />
                <h3 class="text-xl font-semibold mb-2">Control de Acceso</h3>
                <p class="text-gray-500">Gestione permisos y controle quién puede ver, editar o compartir sus documentos.</p>
            </div>
            
            <!-- Tarjeta 4 - IA -->
            <div class="bg-white rounded-lg  p-6 text-center shadow-sm w-full md:w-5/12 lg:w-1/4">
                <CpuChipIcon class="mx-auto mb-4 text-blue-400 w-10 h-10" />
                <h3 class="text-xl font-semibold mb-2">Análisis Inteligente de Hojas de Vida</h3>
                <p class="text-gray-500">Nuestra IA analiza, clasifica y resume hojas de vida para facilitar decisiones de contratación más rápidas y efectivas.</p>
            </div>        
        </div>
    </section>
</template>

<script setup>
import { FolderIcon, LockClosedIcon, CpuChipIcon, ServerStackIcon } from '@heroicons/vue/24/outline'
</script>