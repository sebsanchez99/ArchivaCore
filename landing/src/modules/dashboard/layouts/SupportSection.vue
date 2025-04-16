<template>
    <div class="max-w-6xl mx-auto">
        <h2 class="text-2xl font-bold text-primary-800 mb-1">Centro de Soporte</h2>
        <p class="text-sm text-primary-600 mb-6">Obtenga ayuda y soporte para ArchivaCore</p>
        <div class="grid grid-cols-1 md:grid-cols-12 gap-6">
            <div class="md:col-span-7">
                <OnlineChat />
            </div>

            <div class="md:col-span-5">
                <SupportForm />
            </div>
        </div>

    </div>
</template>

<script lang="ts" setup>
import OnlineChat from "@/modules/dashboard/components/supportSection/OnlineChat.vue";
import SupportForm from "@/modules/dashboard/components/supportSection/SupportForm.vue";
</script>