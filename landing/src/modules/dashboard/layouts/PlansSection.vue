<template>
    <div class="max-w-6xl mx-auto">
        <div>
            <h2 class="text-2xl font-bold text-primary-800 mb-1">Planes y facturación</h2>
            <p class="text-sm text-primary-600 mb-6">Gestione su suscripción y actualice su plan</p>
            <div class="bg-primary-50 border border-primary-100 rounded-xl shandow-sm p-6">
                <div class="flex justify-between">
                    <h3 class="text-xl font-semibold text-primary-800">Su plan actual</h3>
                    <span class="badge badge-outline font-semibold border border-primary-500 text-primary-500">{{ actualPLan.shortName }}</span>
                </div>
                <p class=" text-sm text-primary-600 mb-6 border-b border-primary-300 pb-4 ">Detalles de su suscripción
                    actual</p>
                <div class="grid md:grid-cols-2 xl:grid-cols-2 gap-4 px-4 py-4">
                    <div>
                        <h4 class="text-xl mb-1 font-bold text-primary-600">{{ actualPLan.name }}</h4>
                        <p class="text-sm text-primary-600 mb-2">{{ actualPLan.description }}</p>
                        <ul class="space-y-4 text-sm text-primary-800">
                            <li v-for="(feature, index) in actualPLan.features" :key="index"
                                class="flex items-center gap-3">
                                <span class="bg-white rounded-full p-1 shadow-sm">
                                    <CheckCircleIcon class="w-5 text-primary-500" />
                                </span>
                                <div>
                                    <p>{{ feature }}</p>
                                </div>
                            </li>
                        </ul>
                        <button class="w-full btn mt-4 bg-primary-500 shadow-sm text-white hover:bg-primary-400">Cambiar plan</button>
                    </div>
                    <div>
                        <h4 class="text-xl mb-4 font-bold text-primary-600">Preguntas frecuentes</h4>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref } from "vue";
import type { Plan } from "@/interfaces/plan";
import { CheckCircleIcon } from "@heroicons/vue/24/outline";

const demoPlan: Plan = {
    name: 'Plan DEMO',
    shortName: 'DEMO',
    description: 'Está utilizando una versión de prueba gratuita de ArchivaCore con funcionalidades limitadas.',
    features: [
        'Almacenamiento de 2 GB',
        'Hasta 3 usuarios',
        'Soporte por email',
    ]
}

const demoPro: Plan = {
    name: 'Plan PRO',
    shortName: 'PRO',
    description: 'Esta utilizando una versión PRO de ArchivCore con características ilimitadas.',
    features: [
        'Almacenamiento ilimitado',
        'Usuarios ilimitados',
        'Soporte prioritario 24/7',
    ]
}
const actualPLan = ref<Plan>(demoPlan)
</script>