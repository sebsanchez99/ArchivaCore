<template>
    <div class=" flex flex-col min-h-screen">
        <NavBarAuthSection/>
        <main class="flex-1 flex-col items-center justify-center bg-background-500">
            <RouterView/>
        </main>
    </div>
</template>

<script setup>
import NavBarAuthSection from "@/modules/auth/components/NavBarAuthSection.vue";
</script>