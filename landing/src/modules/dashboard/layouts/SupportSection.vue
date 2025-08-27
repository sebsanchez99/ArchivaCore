<template>
    <div class="max-w-7xl mx-auto">
        <h2 class="text-2xl font-semibold text-text-500 mb-5">Centro de Soporte</h2>
        <OnlineChat />
    </div>
</template>

<script lang="ts" setup>
import OnlineChat from "@/modules/dashboard/components/supportSection/OnlineChat.vue";

defineOptions({ name: 'SupportSection' })
</script>