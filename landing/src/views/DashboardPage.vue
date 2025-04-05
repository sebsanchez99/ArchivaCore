<template>
    <div class="drawer lg:drawer-open">
        <input id="sidebar" type="checkbox" class="drawer-toggle" />

        <!-- Contenido principal -->
        <div class="flex flex-col drawer-content bg-white text-black py-0 h-screen">
            <div class="flex flex-row bg-primary-500 shadow-lg">
                <label for="sidebar"
                    class="btn btn-primary drawer-button lg:hidden m-2 p-1 bg-transparent border-none shadow-2xl">
                    <Bars3Icon class="w-8 h-8" />
                </label>
                <NavBarSection />
            </div>

            <div class="p-5 bg-white">
                <RouterView />
            </div>
        </div>

        <!-- Sidebar -->
        <SideMenuSection />
    </div>
</template>

<script lang="ts" setup>
import SideMenuSection from '@/modules/dashboard/components/SideMenuSection.vue';
import NavBarSection from '@/modules/dashboard/components/NavBarSection.vue';
import { Bars3Icon } from "@heroicons/vue/24/outline";
</script>
