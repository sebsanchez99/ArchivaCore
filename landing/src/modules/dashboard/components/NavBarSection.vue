<template>
    <div class="navbar bg-primary-500 px-6">
        <div class="navbar-start">
            <h1 class="text-xl font-bold text-black">Panel de Administración</h1>
        </div>
        <div class="navbar-end gap-2">
            <button class="btn btn-outline bg-secondary-200 border-none text-white hover:bg-secondary-300 shadow-md">
                <WalletIcon class="w-4" />
                <h3>Gestionar Suscripción</h3>
            </button>
            <button class="btn btn-ghost btn-circle hover:bg-primary-400 border-none shadow-2xl">
                <BellIcon class="w-7 text-white" />
            </button>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { BellIcon, WalletIcon } from "@heroicons/vue/24/solid";
</script>