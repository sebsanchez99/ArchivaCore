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
            </div>

            <div
                class="p-5 bg-gradient-to-b from-accent-50 to-white rounded-lg shadow-inner h-[calc(100vh-4rem)] overflow-y-auto scrollbar-thin scrollbar-thumb-primary-400 scrollbar-track-primary-100">
                <RouterView v-slot="{ Component }">
                    <KeepAlive :include="['SupportSection', 'ClientsChatSection']">
                        <component :is="Component" />
                    </KeepAlive>
                </RouterView>
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
