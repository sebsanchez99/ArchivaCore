<template>
    <div class="drawer lg:drawer-open">
        <input id="sidebar" type="checkbox" class="drawer-toggle" />

        <!-- Contenido principal -->
        <div class="drawer-content bg-white text-black">
            <label for="sidebar"
                class="btn btn-primary drawer-button lg:hidden m-2 p-1 bg-transparent border-none shadow-2xl">
                <Bars3Icon class="w-8 h-8" />
            </label>

            <RouterView />
        </div>

        <!-- Sidebar -->
        <SideMenuSection />
    </div>
</template>

<script lang="ts" setup>
import SideMenuSection from '@/layouts/dashboard/SideMenuSection.vue';
import { Bars3Icon } from "@heroicons/vue/24/outline";
</script>
