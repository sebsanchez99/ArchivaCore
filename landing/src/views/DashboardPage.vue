<template>
    <div class="flex flex-col">
        <main>
            <SideMenuSection/>
            <RouterView/>
        </main>
    </div>
</template>

<script lang="ts" setup>
import SideMenuSection from '@/layouts/dashboard/SideMenuSection.vue'
</script>